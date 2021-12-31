#ENEMY_DISTANSE
extends Node2D
signal state_changed(new_state)

enum State{
	patrol,
	engage
}

onready var Detection = $Detection
onready var patrol_timer=$PatrolTimer

var current_state = -1 setget set_state
var actor:KinematicBody2D = null
var player: Player = null
var weapon: Weapon = null

# Статус патруля 
var origin:Vector2 = Vector2.ZERO
var patrol_location:Vector2=Vector2.ZERO
var patrol_location_reached:bool=false
var actor_velocity:Vector2=Vector2.ZERO
# Статус патруля 

func _ready() -> void:
	set_state(State.patrol)

func _physics_process(delta: float) ->void:
	match current_state:
		State.patrol:
			if not patrol_location_reached:
				actor.move_and_slide(actor_velocity)
				actor.rotate_toward(patrol_location)
				if actor.global_position.distance_to(patrol_location)<5:
					patrol_location_reached=true
					actor_velocity=Vector2.ZERO
					patrol_timer.start()
		State.engage:
			if player != null and weapon !=null:
				actor.rotate_toward(player.global_position)
				var angle_player=global_position.direction_to(player.global_position).angle()
				if abs(actor.rotation-angle_player)<0.1:
					weapon.shoot()
			else:
				pass
		_:
			print("ошиба патроль")

func initalize(actor,weapon: Weapon):
	self.actor=actor
	self.weapon=weapon

func set_state(new_state:int):
	if new_state==current_state:
		return
	if new_state==State.patrol:
		origin=global_position
		patrol_timer.start()
		patrol_location_reached=true
		
	current_state=new_state
	emit_signal("state_changed",current_state)

func _on_Detection_body_entered(body):
	if body.is_in_group("Player"):
		set_state(State.engage)
		player=body
	
	


func _on_Detection_body_exited(body):
	if player and body == player:
		set_state(State.patrol)
		player=null


func _on_PatrolTimer_timeout():
	
	var patrol_range=30
	var random_x=rand_range(-patrol_range,patrol_range)
	var random_y=rand_range(-patrol_range,patrol_range)
	patrol_location=Vector2(random_x,random_y)+origin
	patrol_location_reached=false
	actor_velocity = actor.velocity_toward(patrol_location)
