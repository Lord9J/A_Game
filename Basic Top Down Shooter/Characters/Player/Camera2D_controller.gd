extends Camera2D

var zoom_min = Vector2(.16,.16)
var zoom_max=Vector2(0.315,0.315)
var zoom_speed=Vector2(0.05,0.05)
var des_zoom=zoom

func _process(delta):
	
	zoom=lerp(zoom,des_zoom,.2)
	
func _input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index==BUTTON_WHEEL_UP:
				if des_zoom>zoom_min:
					des_zoom-=zoom_speed
			if event.button_index==BUTTON_WHEEL_DOWN:
				if des_zoom<zoom_max:
					des_zoom+=zoom_speed
