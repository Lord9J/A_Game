#extends Character
extends KinematicBody2D

class_name Player

# --- движение ----
export(int) var max_speed: int = 100
export(int) var accerelation: int = 40
export(bool) var flying: bool = false
var mov_direction: Vector2 = Vector2.ZERO
var velocity: Vector2 = Vector2.ZERO
# --- движение ----

var ammo
var can_take_damage=true

# ----  Инициализирует переменную, как только Узел,   -----
# к которому прикреплен скрипт, а также его дети являются частью дерева сцен.
onready var hp_stat=$Health 
onready var weapon = $Weapon

# ------------------------------------------
	
func _ready():
	Globals.set_ammo(weapon.ammo)	
	
func _physics_process(delta):
	
	var move_vec = Vector2()

	var isMoving: bool=false
	if Input.is_action_pressed("move_up"):
		$AnimatedSprite.play("walk")
		isMoving=true
		move_vec.y -= 1
	if Input.is_action_pressed("move_down"):
		$AnimatedSprite.play("walk")
		isMoving=true
		move_vec.y += 1
	if Input.is_action_pressed("move_left"):
		$AnimatedSprite.play("walk")
		isMoving=true
		move_vec.x -= 1
	if Input.is_action_pressed("move_right"):
		$AnimatedSprite.play("walk")
		isMoving=true
		move_vec.x += 1
		
	
	if (!isMoving):
		$AnimatedSprite.play("idle")

	move_vec = move_vec.normalized()
	move_and_collide(move_vec * max_speed * delta)
	
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
			yield(get_tree().create_timer(1),"timeout")
			can_take_damage=true
		
	
