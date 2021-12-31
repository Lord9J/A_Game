#MEELEE
extends Node2D
signal state_changed(new_state)

enum State{
	patrol,
	engage
}

onready var Detection = $Detection
onready var patrol_timer=$PatrolTimer
onready var c_attack=$Attack
onready var los = $RayCast2D

var current_state = -1 setget set_state
var actor:KinematicBody2D = null
var player: Player = null
var can_attack=false

# Статус патруля 
var origin:Vector2 = Vector2.ZERO
var patrol_location:Vector2=Vector2.ZERO
var patrol_location_reached:bool=false
var actor_velocity:Vector2=Vector2.ZERO
# Статус патруля 


	# навигация
var path: Array = []	# Contains destination positions
var levelNavigation: Navigation2D = null
var player_spotted: bool = false
	# навигация


var vis_color = Color(.867, .91, .247, 0.1)
export (int) var detect_radius
var hit_pos
var target


func _ready() -> void:
	set_state(State.patrol)
	
	
	yield(get_tree(), "idle_frame")
	var tree = get_tree()
	if tree.has_group("LevelNavigation"):
		levelNavigation = tree.get_nodes_in_group("LevelNavigation")[0]
	if tree.has_group("Player"):
		player = tree.get_nodes_in_group("Player")[0]
		
		
	var shape = CircleShape2D.new()
	shape.radius = detect_radius
	$Detection/CollisionShape2D.shape = shape


func _physics_process(delta: float) ->void:
	update()
	match current_state:
		State.patrol:
			if not patrol_location_reached:
				actor.move_and_slide(actor_velocity)
				actor.rotate_toward(patrol_location)
				if actor.global_position.distance_to(patrol_location)<5:
					patrol_location_reached=true
					actor_velocity=Vector2.ZERO
					patrol_timer.start()
					actor.anim_idle()
					
		
		State.engage:
			if player != null: #===========если игрок присутсвует=======
					
		
				#===========поворот к игроку=======
				#actor.rotate_toward(player.global_position)
				#===========поворот к игроку=======
				
				
				if (can_attack==false):
					
					los.look_at(player.global_position)
					check_player_in_detection()
					if player_spotted:
						actor.generate_path()
						actor.navigate()
					actor.move()
	
					#===========анимация ходьбы=======
					actor.anim_walk()
					#===========анимация ходьбы=======
				
					
				#===========вычитание и проверка попадания игрока в поле зрения (возможность атаки)=======
				var angle_player=global_position.direction_to(player.global_position).angle()
				if abs(actor.rotation-angle_player)<0.1:
				#===========вычитание и проверка попадания игрока в поле зрения (возможность атаки)=======
							
					#===========если игрок в поле зрении и атака не начата то начать атаку=======
					if (can_attack==true and c_attack.is_stopped()):
	#						print("начал кушать")
						actor.anim_attack()
						c_attack.start()
					#===========если игрок в поле зрении и атака не начата то начать атаку=======
						
						
						
			else: #===========если увидел кого то другого=======
				pass
		_:
			print("ошиба патроль")


func aim():
	hit_pos = []
	var space_state = get_world_2d().direct_space_state
	var target_extents = target.get_node('CollisionShape2D').shape.extents - Vector2(5, 5)
	var nw = target.position - target_extents
	var se = target.position + target_extents
	var ne = target.position + Vector2(target_extents.x, -target_extents.y)
	var sw = target.position + Vector2(-target_extents.x, target_extents.y)
	for pos in [target.position, nw, ne, se, sw]:
		var result = space_state.intersect_ray(position,
				pos, [self], actor.collision_mask)
		if result:
			hit_pos.append(result.position)
			$AnimatedSprite.self_modulate.r = 1.0
			
			rotation = (target.position - position).angle()
			break


func _draw():
	draw_circle(Vector2(), detect_radius, vis_color)
	if target:
		for hit in hit_pos:
			draw_circle((hit - position).rotated(-rotation), 5, actor.laser_color)
			draw_line(Vector2(), (hit - position).rotated(-rotation), actor.aclaser_color)







func check_player_in_detection() -> bool:
	var collider = los.get_collider()
	if collider and collider.is_in_group("Player"):
		player_spotted = true
		print("raycast collided")	# Debug purposes
		return true
	return false


func initalize(actor):
	self.actor=actor


func set_state(new_state:int):
	if new_state==current_state:
		return
	if new_state==State.patrol:
		origin=global_position
		patrol_timer.start()
		patrol_location_reached=true
		
	current_state=new_state
	emit_signal("state_changed",current_state)

func _on_Detection_body_entered(body):
	if body.is_in_group("Player"):
		set_state(State.engage)
		player=body
		
	if target:
		return
	target = body
	
	


func _on_Detection_body_exited(body):
	pass



func _on_Memory_body_entered(body):
	pass # Replace with function body.


func _on_Memory_body_exited(body):
	if player and body == player:
		set_state(State.patrol)
		player=null
		actor.anim_idle()


func _on_PatrolTimer_timeout():
	actor.anim_walk()
	var patrol_range=25
	var random_x=rand_range(-patrol_range,patrol_range)
	var random_y=rand_range(-patrol_range,patrol_range)
	patrol_location=Vector2(random_x,random_y)+origin
	patrol_location_reached=false
	actor_velocity = actor.velocity_toward(patrol_location)



func _on_HitArea_body_entered(body):
	if player and body == player:
		can_attack=true
		set_state(State.engage)


func _on_HitArea_body_exited(body):
	if player and body == player:
		set_state(State.patrol)
		c_attack.stop()
		can_attack=false
		set_state(State.engage)




