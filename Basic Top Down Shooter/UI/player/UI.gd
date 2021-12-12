extends CanvasLayer

var parent_rotation 
onready var fps_label = $fps_label
onready var hp_bar=$HPBar/TextureProgress

func _ready():
	hp_bar.value=100
	

func set_percent_value_int(value):
	hp_bar.value=value



func _process(delta):
	set_percent_value_int(Globals.player_hp)
	fps_label.set_text("FPS: "+str(Engine.get_frames_per_second()))



