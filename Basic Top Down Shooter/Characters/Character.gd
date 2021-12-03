extends KinematicBody2D
class_name Character, "res://ARTs/player/idle.png"


#const HIT_EFFECT_SCENE: PackedScene = preload("res://Characters/HitEffect.tscn")

const FRICTION: float = 0.15

export(int) var max_hp: int = 2
export(int) var hp: int = 2 setget set_hp
signal hp_changed(new_hp)

export(int) var accerelation: int = 40
export(int) var max_speed: int = 100

export(bool) var flying: bool = false

onready var state_machine: Node = get_node("FiniteStateMachine")
onready var animated_sprite: AnimatedSprite = get_node("AnimatedSprite")

var mov_direction: Vector2 = Vector2.ZERO
var velocity: Vector2 = Vector2.ZERO


func _physics_process(_delta: float) -> void:
	velocity = move_and_slide(velocity)
	velocity = lerp(velocity, Vector2.ZERO, FRICTION)
	
	
func move() -> void:
	mov_direction = mov_direction.normalized()
	velocity += mov_direction * accerelation
	velocity = velocity.clamped(max_speed)
	
	
	
func take_damage(dam: int) -> void:
		self.hp -= dam
		print(hp)
		#_update_health_bar(hp)

		
func set_hp(new_hp: int) -> void:
	hp = clamp(new_hp, 0, max_hp)
	emit_signal("hp_changed", hp)
	
	
	



