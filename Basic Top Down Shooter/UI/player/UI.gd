extends CanvasLayer

var parent_rotation 
onready var fps_label = $All/fps_label
onready var hp_bar=$All/HPBar/TextureProgress
onready var ammo_label=$All/VBoxContainer/HBoxContainer/ammo_label
onready var progers=$All/VBoxContainer2/HBoxContainer/ammoProgress

func _ready():
	hp_bar.value=100
	

func set_percent_value_int(value):
	hp_bar.value=value



func _process(delta):
	set_percent_value_int(Globals.player_hp)
	
	# =========   Счетчит кадров =========  
	fps_label.set_text("FPS: "+str(Engine.get_frames_per_second()))
	# =========   Счетчит кадров =========  
	
	
	
	# =========   Счетчит патронов и перезарядки =========  
	if Globals.player_ammo>0:
		progers.value=0
		ammo_label.visible=true
		progers.visible=false
		ammo_label.set_text(str(Globals.player_ammo)+"/30")
	else:
		ammo_label.visible=false
		progers.visible=true
		progers.value+=1
	# =========   Счетчит патронов и перезарядки =========  
	
	
	
	#  =========  Скрывать интерфейс когда консоль открыт =========  
	if Globals.p_cons==true:
		$All.visible=false
	else:
		if Globals.p_cons==false:
			$All.visible=true
	#  =========  Скрывать интерфейс когда консоль открыт =========  	
	
	
	# =========  Открытие главного меню =========  
	if Input.is_action_just_released("ui_esc") and $All/MarginContainer/VBoxContainer/But_e.visible==false:
		if $GameMenu.visible==false:
			$GameMenu.visible=true
			
		else:
			if $GameMenu.visible==true:
				$GameMenu.visible=false
	#=========   Открытие главного меню	=========  		
		
		





func _on_New_Game2_pressed():
	$GameMenu.visible=false
	get_tree().set_deferred("paused", false)
