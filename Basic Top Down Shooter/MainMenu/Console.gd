extends Control

onready var info = $All/S/Opis
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	
	# =========  Открытие консоля выбора мисиии. игру в паузу =========  
	if 	Globals.p_cons==true:
		$All.visible=true
		get_tree().set_deferred("paused", true)
	
	if Input.is_action_just_pressed("ui_esc"):
		$All.visible=false
		Globals.p_cons=false
		get_tree().set_deferred("paused", false)
	# =========  Открытие консоля выбора мисиии. игру в паузу =========  
		
		
	

func _on_Button_pressed():
	$All.visible=false
	Globals.p_cons=false
	get_tree().change_scene("res://WORLDS/TDS.tscn")
	get_tree().set_deferred("paused", false)
	


func _on_Button_mouse_entered():
	$All/Mis/Map1.visible=true
	info.set_text("Описание первого задания")


func _on_Button_mouse_exited():
	$All/Mis/Map1.visible=false
	info.set_text(" ")


func _on_Button_nazad_pressed():
	$All.visible=false
	Globals.p_cons=false
	get_tree().set_deferred("paused", false)
