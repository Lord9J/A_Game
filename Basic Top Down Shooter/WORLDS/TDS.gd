extends Node2D

onready var bullet_manager = $BulletManager
onready var player:Player = $Player
onready var nav = $Navigation2D

#onready var zombie = preload("res://Characters/Enemy/Zombie.tscn")

func _ready() -> void:
	randomize()
	#var z = zombie.instance()
#	z.position = Vector2(489, 270)
#	add_child(z)

	GlobalSignals.connect("bullet_fired",bullet_manager,"handle_bullet_spawned")
 
