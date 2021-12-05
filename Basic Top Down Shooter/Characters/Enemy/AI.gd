extends Node2D
signal state_changed(new_state)

enum State{
	patrol,
	engage
}

onready var Detection = $Detection

var current_state = State.patrol setget set_state
var player: Player = null
var weapon: Weapon = null

func _process(delta: float) ->void:
	match current_state:
		State.patrol:
			pass
		State.engage:
			if player != null and weapon !=null:
				weapon.shoot()
			else:
				print("нуль")
		_:
			print("ошиба патроль")

func set_weapon(weapon: Weapon):
	self.weapon=weapon

func set_state(new_state:int):
	if new_state==current_state:
		return
	current_state=new_state
	emit_signal("state_changed",current_state)

func _on_Detection_body_entered(body):
	
	if body.is_in_group("Player"):
		set_state(State.engage)
		player=body
		print("заметил чела")
	


func _on_Detection_body_exited(body):
	pass # Replace with function body.
