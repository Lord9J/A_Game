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
var spot=false

# Статус патруля 
var origin:Vector2 = Vector2.ZERO
var patrol_location:Vector2=Vector2.ZERO
var patrol_location_reached:bool=false
var actor_velocity:Vector2=Vector2.ZERO
# Статус патруля 


	# навигация
var path: Array = []	# Contains destination positions
var levelNavigation: Navigation2D = null

	# навигация




func _ready() -> void:
	set_state(State.patrol)
	
	
	yield(get_tree(), "idle_frame")
	var tree = get_tree()
	if tree.has_group("LevelNavigation"):
		levelNavigation = tree.get_nodes_in_group("LevelNavigation")[0]
	if tree.has_group("Player"):
		player = tree.get_nodes_in_group("Player")[0]
		


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
					patrol_timer.wait_time=rand_range(2,5)
					
					
		
		State.engage:
			if player != null: #===========если игрок присутсвует=======
					

				#===========поворот к игроку=======
				#actor.rotate_toward(player.global_position)	
				#===========поворот к игроку=======
				
				
				if (can_attack==false):
					
					los.look_at(player.global_position)
					actor.generate_path()
					actor.navigate()
					actor.move()
	
					#===========анимация ходьбы=======
					actor.anim_walk()
					#===========анимация ходьбы=======
					
				if (can_attack==true):
					actor.rotate_toward(player.global_position)	

				#===========вычитание и проверка попадания игрока в поле зрения (возможность атаки)=======
				var angle_player=global_position.direction_to(player.global_position).angle()
				if abs(actor.rotation-angle_player)<0.2:
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


# обнаружение игрока вблизи
func _on_Detection_body_entered(body):
	if body.is_in_group("Player"):
		set_state(State.engage)
		player=body
		spot=true
		

	
	


func _on_Detection_body_exited(body):
	pass



func _on_Memory_body_entered(body):
	pass # Replace with function body.


func _on_Memory_body_exited(body):
	if player and body == player:
		set_state(State.patrol)
		player=null
		actor.anim_idle()
		spot=false


func _on_PatrolTimer_timeout():
	actor.anim_walk()
	
	var patrol_range=30
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
		




