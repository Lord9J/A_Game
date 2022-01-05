extends Node


export (int) var player_speed
export (int) var player_hp
export (int) var player_ammo

var player_esc
var player = null


# Called when the node enters the scene tree for the first time.
func _ready():
	player_hp=100
	player_speed=140
	player_esc=false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player_hp<=0:
		get_tree().change_scene("res://MainMenu/Menu.tscn")
		get_tree().set_deferred("paused", true)


func set_ammo(ammo):
	player_ammo=ammo
