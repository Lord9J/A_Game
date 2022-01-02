extends Area2D
class_name Bullet

var Effect =preload("res://Bullet/hole_effect.tscn")

export (int) var speed = 10
export (int) var damage = 20

var direction :=Vector2.ZERO

export var smokeScene : PackedScene


func _physics_process(delta:float) -> void:
	if direction!=Vector2.ZERO:
		var velocity=direction*speed
		
		global_position +=velocity
	

func set_direction (direction:Vector2):
	self.direction=direction
	rotation+=direction.angle()


func _on_Timer2_timeout():
	queue_free()



		


func _on_Area2D_body_entered(body):
	
	if body.is_in_group("Enemy"):
		pass
	else:
		var effect = Effect.instance()
		get_tree().get_root().add_child(effect)
		effect.global_transform=global_transform
	

	
	if body.is_in_group("Player"):
		Globals.player_hp-=damage;
		
	queue_free()


func _on_Bullet_body_entered(body):
	
	queue_free()
