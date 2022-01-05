extends CanvasLayer

var parent_rotation 
onready var fps_label = $fps_label
onready var hp_bar=$HPBar/TextureProgress
onready var ammo_label=$VBoxContainer/HBoxContainer/ammo_label
onready var progers=$VBoxContainer2/HBoxContainer/ammoProgress
onready var ui2 = $GameMenu

func _ready():
	hp_bar.value=100
	

func set_percent_value_int(value):
	hp_bar.value=value



func _process(delta):
	set_percent_value_int(Globals.player_hp)
	fps_label.set_text("FPS: "+str(Engine.get_frames_per_second()))
	
	if Globals.player_ammo>0:
		progers.value=0
		ammo_label.visible=true
		progers.visible=false
		ammo_label.set_text(str(Globals.player_ammo)+"/30")
	else:
		ammo_label.visible=false
		progers.visible=true
		progers.value+=1
	
	if Input.is_action_just_released("ui_esc"):
		if $GameMenu.visible==false:
			$GameMenu.visible=true
			
		else:
			if $GameMenu.visible==true:
		#	
				$GameMenu.visible=false
				
		
		





func _on_New_Game2_pressed():
	$GameMenu.visible=false
	get_tree().set_deferred("paused", false)
