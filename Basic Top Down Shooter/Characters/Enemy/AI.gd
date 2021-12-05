extends Node2D
signal state_changed(new_state)

enum State{
	patrol,
	engage
}

onready var Detection = $Detection

var current_state = State.patrol setget set_state
var player = null

func set_state(new_state:int):
	if new_state==current_state:
		return
	current_state=new_state
	emit_signal("state_changed",current_state)

func _on_Detection_body_entered(body):
	if body.is_in_group("player"):
		set_state(State.engage)
		player=body


func _on_Detection_body_exited(body):
	pass # Replace with function body.
