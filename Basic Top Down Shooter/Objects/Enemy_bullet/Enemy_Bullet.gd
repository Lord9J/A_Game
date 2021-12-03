extends KinematicBody2D
#$extends Area2D

var speed = 300
var damage = 20
var move = Vector2.ZERO
var look_vec = Vector2.ZERO
var player = null


export var smokeScene : PackedScene

var direction = Vector2.ZERO

func _ready():
	look_vec = player.position - global_position

func _physics_process(delta):
	move = Vector2.ZERO
	move = move.move_toward(look_vec,delta)
	move =move.normalize() * speed
	position += move


