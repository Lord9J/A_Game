#extends Character
extends KinematicBody2D

class_name Player



# --- движение ----

export(int) var accerelation: int = 40
export(bool) var flying: bool = false
var mov_direction: Vector2 = Vector2.ZERO
var velocity: Vector2 = Vector2.ZERO
# --- движение ----

var shake_amount = 1.0
var reload=false
var ammo
var can_take_damage=true
var eat=false #чтобы терял по 1 хп когда зомби ест

# ----  Инициализирует переменную, как только Узел,   -----
# к которому прикреплен скрипт, а также его дети являются частью дерева сцен.
onready var hp_stat=$Health 
onready var weapon = $Weapon
onready var camera=$Camera2D
onready var ui = $UI/GameMenu

# ------------------------------------------
	
func _ready():
	Globals.set_ammo(weapon.ammo)	
	Globals.player=self
	
	
func _physics_process(delta):
	
	# ----- включение и выключение фонаря ----
	if Input.is_action_just_pressed("ui_flashlight"):
		if $FlashLight.visible==false:
			$FlashLight.visible=true
		else:
			if $FlashLight.visible==true:
				$FlashLight.visible=false		
	# ----- включение и выключение фонаря ----
	
	
	
	# Движение камеры след за курсором
	var mouse_pos=get_global_mouse_position()
	camera.offset_h=(mouse_pos.x-global_position.x)/(1920/2.0)
	camera.offset_v=(mouse_pos.y-global_position.y)/(1080/2.0)
	# Движение камеры след за курсором



	# ----- движение игрока   ----
	var move_vec = Vector2()
	
	var isMoving: bool=false
	if Input.is_action_pressed("move_up"):
		if (reload==false):
			$AnimationPlayer.play("walk")
		isMoving=true
		move_vec.y -= 1
	if Input.is_action_pressed("move_down"):
		if (reload==false):
			$AnimationPlayer.play("walk")
		isMoving=true
		move_vec.y += 1
	if Input.is_action_pressed("move_left"):
		if (reload==false):
			$AnimationPlayer.play("walk")
		isMoving=true
		move_vec.x -= 1
	if Input.is_action_pressed("move_right"):
		if (reload==false):
			$AnimationPlayer.play("walk")
		isMoving=true
		move_vec.x += 1
	
	# -----  бег   ----
	if Input.is_action_pressed("ul_shift"):
		Globals.player_speed=300
	if Input.is_action_just_released("ul_shift"):	
		Globals.player_speed=140	
	# ----- бег   ----
	
	
	# ----- движение игрока   ----
		
	
	

	if (!isMoving):
		if (reload==false):
			$AnimationPlayer.play("idle")

	move_vec = move_vec.normalized()
	move_and_collide(move_vec * Globals.player_speed * delta)
	
	var look_vec =(get_global_mouse_position() - global_position)
	global_rotation = atan2(look_vec.y, look_vec.x)
	
	
	if Globals.player_ammo==0:
		reload=true
		$AnimationPlayer.play("reload")
	else:
		reload=false
	
	

	
	
	# ---    стрельба    ----
	if Input.is_action_pressed("shoot"):
		weapon.shoot()
		
		# ---- дрожание камеры ------
		if Globals.player_ammo!=0:
			camera.set_offset(Vector2( \
			rand_range(-0.7, 0.7) * shake_amount, \
			rand_range(-0.7, 0.7) * shake_amount \
		))
		# ---- дрожание камеры -----


	# --- игрока ест зомби ---
	if (eat==true):
		Globals.player_hp-=0.2
		Globals.player_speed=40
	
	
	# нажал открыть консоль
	if Input.is_action_just_pressed("ui_e"):
		Globals.p_cons=true
		
		
# получение урона
func _on_HurtBox_area_entered(body):
	if body.is_in_group("enemy_hit") and can_take_damage :
			Globals.player_hp-=10
			can_take_damage=false
			yield(get_tree().create_timer(1),"timeout")
			can_take_damage=true
			
	if body.is_in_group("enemy_eat") :	
			eat=true
		

func _on_HurtBox_area_exited(area):
	eat=false
	Globals.player_speed=140


# =========  Подсказка взаимодействия с консолем =========  
func _on_Console_body_entered(body):
	if body.is_in_group("Player"):
		$UI/All/MarginContainer/VBoxContainer/But_e.visible=true
		Globals.p_pod=true
# =========  Подсказка взаимодействия с консолем =========  


func _on_Console_body_exited(body):
	if body.is_in_group("Player"):
		$UI/All/MarginContainer/VBoxContainer/But_e.visible=false
		Globals.p_pod=false
		

