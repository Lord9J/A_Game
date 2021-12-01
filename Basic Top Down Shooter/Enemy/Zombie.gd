extends KinematicBody2D

const MOVE_SPEED = 40

onready var raycast = $RayCast2D

export(int) var hp=100
var max_hp = hp

var player = null


func _ready():
	add_to_group("zombies")
	

func _physics_process(delta):
	if player == null:
		return
	
	var vec_to_player = player.global_position - global_position
	vec_to_player = vec_to_player.normalized()
	global_rotation = atan2(vec_to_player.y, vec_to_player.x)
	move_and_collide(vec_to_player * MOVE_SPEED * delta)
	



func set_player(p):
	player = p




# попал пулей по зомби
func _on_HurtBox_area_entered(body):
	if body.is_in_group("bullet"):
		
		
		hp=hp-15
		$HPBar.set_percent_value_int(float(hp)/max_hp*100)
		if hp<=0:
		 queue_free()
