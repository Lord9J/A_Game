extends KinematicBody2D

export var speed = 300
var damage = 20

export var smokeScene : PackedScene

var direction = Vector2.ZERO

func _ready():
	pass

func _process(delta):
	var collisionResult = move_and_collide(direction * speed * delta)
	
	if collisionResult != null:
		var smoke = smokeScene.instance() as Particles2D
		get_parent().add_child(smoke)
		smoke.global_position = collisionResult.position
		smoke.rotation = collisionResult.normal.angle()
		queue_free()

func _on_HitBox_area_entered(area):
	queue_free()


func _on_Timer_timeout():
	queue_free()
