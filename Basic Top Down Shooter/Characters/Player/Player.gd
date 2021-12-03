extends Character
enum {UP, DOWN}


# ---   стрельба        ----
export var bulletScene : PackedScene    # префаб пули
export var bullet_speed = 500
export var fire_rate=0.1
var can_fire=true
var can_take_damage=true
# ---   стрельба        ----

#func _ready():
#	yield(get_tree(), "idle_frame")
#	get_tree().call_group("zombies", "set_player", self)
	
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
	if Input.is_action_pressed("shoot") and can_fire:
		
		var bullet = bulletScene.instance() as Node2D
		get_parent().add_child(bullet)
		bullet.global_position = $BulletPoint.global_position
		bullet.direction = (get_global_mouse_position() - global_position).normalized()
		bullet.rotation = bullet.direction.angle()
		can_fire=false
		yield(get_tree().create_timer(fire_rate),"timeout")
		can_fire=true
	
	




# получение урона
func _on_HurtBox_area_entered(body):
	if body.is_in_group("enemy_hit") and can_take_damage :
			take_damage(10)
			can_take_damage=false
			print("НЕ ПОЛУЧАЮ УРОН")
			yield(get_tree().create_timer(1),"timeout")
			can_take_damage=true
			print("получаю урон")
		
		

func animate():
	var anim="walk"
