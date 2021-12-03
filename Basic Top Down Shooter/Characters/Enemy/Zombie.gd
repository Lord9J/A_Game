extends KinematicBody2D

const MOVE_SPEED = 1

onready var BULLET_SCENE = preload("res://Objects/Enemy_bullet/Enemy_Bullet.tscn")

export(int) var hp=100
var max_hp = hp

var player = null

var move = Vector2.ZERO


#func _ready():
#	add_to_group("zombies")
	

func _physics_process(delta):
	move = Vector2.ZERO#	
	if player != null:
		move = position.direction_to(player.position)*MOVE_SPEED
	else:
		move = Vector2.ZERO
#	
	move = move.normalized()
	move = move_and_collide(move)
#	var vec_to_player = player.global_position - global_position
#	vec_to_player = vec_to_player.normalized()
#	global_rotation = atan2(vec_to_player.y, vec_to_player.x)
#	move_and_collide(vec_to_player * MOVE_SPEED * delta)
	



func set_player(p):
	player = p




# попал пулей по зомби
func _on_HurtBox_area_entered(body):
	if body.is_in_group("bullet"):
		hp=hp-15
		$HPBar.set_percent_value_int(float(hp)/max_hp*100)
		if hp<=0:
		 queue_free()




func _on_Trigger_body_entered(body):
	if body != self:
		player= body


func _on_Trigger_body_exited(body):
	player = null	

func _on_Timer_timeout():
	if player !=null:
		fire()
	
func fire():
	print("пытаюсь стрелять")
	var bullet=BULLET_SCENE.instance()
	bullet.position=get_global_position()
	bullet.player=player
	get_parent().add_child(bullet)
	$Timer.set_wait_time(1)
