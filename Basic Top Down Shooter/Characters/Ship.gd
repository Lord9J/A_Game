#extends Character
extends KinematicBody2D

class_name Ship

# --- движение ----

export(int) var max_speed: int = 200
var mov_direction: Vector2 = Vector2.ZERO
export var friction = 0.01
export var acceleration = 0.01
var velocity = Vector2()
# --- движение ----

var can_take_damage=true


# ----  Инициализирует переменную, как только Узел,   -----
# к которому прикреплен скрипт, а также его дети являются частью дерева сцен.
onready var hp_stat=$Health 
onready var weapon = $Weapon
	
# ------------------------------------------
func get_input():
	var input = Vector2()
	if Input.is_action_pressed('move_right'):
		input.x += 1
	if Input.is_action_pressed('move_left'):
		input.x -= 1
	if Input.is_action_pressed('move_down'):
		input = Vector2(-max_speed, 0).rotated(rotation)
	if Input.is_action_pressed('move_up'):
		input = Vector2(max_speed, 0).rotated(rotation)
		
	return input
	
func _physics_process(delta):
	var direction = get_input()
	
	if direction.length() > 0:
		velocity = lerp(velocity, direction.normalized() * max_speed, acceleration)
	else:
		velocity = lerp(velocity, Vector2.ZERO, friction)
		
	velocity = move_and_slide(velocity)


	var look_vec = get_global_mouse_position() - global_position
	
	global_rotation = atan2(look_vec.y, look_vec.x)

	
	# ---    стрельба    ----
	if Input.is_action_pressed("shoot"):
		weapon.shoot()
	
	



# получение урона
func _on_HurtBox_area_entered(body):
	if body.is_in_group("enemy_hit") and can_take_damage :
			Globals.player_hp-=10
			can_take_damage=false
			print("hp = ",hp_stat.hp)
			yield(get_tree().create_timer(1),"timeout")
			can_take_damage=true
		
		

func animate():
	var anim="walk"
