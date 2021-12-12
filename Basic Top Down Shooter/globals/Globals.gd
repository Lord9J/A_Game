extends Node



export (int) var player_hp

# Called when the node enters the scene tree for the first time.
func _ready():
	player_hp=100


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player_hp<=0:
		print("you die")
		player_hp=100
