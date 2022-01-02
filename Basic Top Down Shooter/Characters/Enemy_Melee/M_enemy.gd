extends KinematicBody2D
class_name M_enemy

var player = null

# --- движение ----
var move = Vector2.ZERO
export(int) var speed=50



# --- движение ----


# ----  Инициализирует переменную, как только Узел,   -----
# к которому прикреплен скрипт, а также его дети являются частью дерева сцен.
onready var hp_stat=$health 
onready var ai = $M_AI	
onready var hp_bar=$HPBar
onready var sprite=$AnimatedSprite
	
# ------------------------------------------
var velocity: Vector2 = Vector2.ZERO
var rotation_speed = PI

var blood = load("res://Presets/Blood.tscn")


func _ready() ->void:
	ai.initalize(self)
	
	
	yield(get_tree(), "idle_frame")
	var tree = get_tree()
	if tree.has_group("LevelNavigation"):
		ai.levelNavigation = tree.get_nodes_in_group("LevelNavigation")[0]
	if tree.has_group("Player"):
		player = tree.get_nodes_in_group("Player")[0]


	

	
func _process(delta):

	if hp_stat.hp<=0:
		var blood_instance=blood.instance()
		get_tree().current_scene.add_child(blood_instance)
		blood_instance.global_position=global_position
		blood_instance.rotation=global_position.angle_to_point(player.global_position)
		
		queue_free();

	#  ====== поворот =========
	if ai.spot:
		var v = player.global_position - global_position
		var angle=velocity.angle()
		var r = rotation
		var angle_delta=rotation_speed*delta
		angle=lerp_angle(r,angle,1.0)
		angle=clamp(angle,r-angle_delta,r+angle_delta)
		rotation=angle
	# ==========================
	
	#rotation =lerp_angle(rotation,velocity.angle(),0.1)
	
	
	



func generate_path():	
	if ai.levelNavigation != null and ai.player != null:
		ai.path = ai.levelNavigation.get_simple_path(global_position, ai.player.global_position, false)

func navigate():	# Определите следующую позицию для перехода
	if ai.path.size() > 0:
		velocity = global_position.direction_to(ai.path[1]) * speed
		
	
		
		# Если вы достигли пункта назначения, удалите эту точку из массива путей
		if global_position == ai.path[0]:
			ai.path.pop_front()

func move():
	velocity = move_and_slide(velocity)


# 100% поворт игроку вблизи
func rotate_toward(location:Vector2):
	rotation=lerp_angle(rotation,global_position.direction_to(location).angle(),1.0)

	
func velocity_toward(location:Vector2 )->Vector2:
	return global_position.direction_to(location)*20

func move_slide():
	return move_and_slide(Vector2(speed,0).rotated(rotation))
	
func anim_walk():
	return 	$AnimatedSprite.play("walk")
	
func anim_idle():
	return 	$AnimatedSprite.play("idle")
	
func anim_attack():
	return 	$AnimatedSprite.play("attack")








#  ============ попал пулей по зомби ================
func _on_HurtBox_area_entered(body):
	if body.is_in_group("Bullet"):
		hp_stat.hp=hp_stat.hp-20
		$HPBar.set_percent_value_int(float(hp_stat.hp)/hp_stat.max_hp*100)
		
		ai._on_Detection_body_entered(player)
		

func _on_Trigger_body_exited(body):
	player = null	














