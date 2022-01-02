extends Node


export (int) var player_speed
export (int) var player_hp
export (int) var player_ammo


var player = null


# Called when the node enters the scene tree for the first time.
func _ready():
	player_hp=100
	player_speed=140


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player_hp<=0:
		print("you die")
		player_hp=100


func set_ammo(ammo):
	player_ammo=ammo
