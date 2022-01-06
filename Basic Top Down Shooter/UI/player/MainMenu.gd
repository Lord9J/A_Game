extends MarginContainer



func _on_Settings3_pressed():
	get_tree().quit()


func _on_Settings_pressed():
	get_tree().change_scene("res://MainMenu/MainMenu.tscn")


func _on_New_Game_pressed():
	get_tree().change_scene("res://MainMenu/Settings.tscn")


