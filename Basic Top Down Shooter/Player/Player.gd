extends KinematicBody2D

signal hit


const MOVE_SPEED = 300

# ---    стрельба    ----
const bullet = preload('res://Presets/Bullet.tscn')  # префаб пули
export var bullet_speed = 500
export var fire_rate=0.1
var can_fire=true
# ---   стрельба        ----



onready var raycast = $RayCast2D

func _ready():
	yield(get_tree(), "idle_frame")
	get_tree().call_group("zombies", "set_player", self)

func _physics_process(delta):
	var move_vec = Vector2()
	if Input.is_action_pressed("move_up"):
		move_vec.y -= 1
	if Input.is_action_pressed("move_down"):
		move_vec.y += 1
	if Input.is_action_pressed("move_left"):
		move_vec.x -= 1
	if Input.is_action_pressed("move_right"):
		move_vec.x += 1
	move_vec = move_vec.normalized()
	move_and_collide(move_vec * MOVE_SPEED * delta)
	
	var look_vec = get_global_mouse_position() - global_position
	global_rotation = atan2(look_vec.y, look_vec.x)
	
	
	# ---    стрельба    ----
	if Input.is_action_pressed("shoot") and can_fire:
		var bullet_instance= bullet.instance()
		bullet_instance.position=$BulletPoint.get_global_position()
		bullet_instance.rotation_degrees=rotation_degrees
		bullet_instance.apply_impulse(Vector2(), Vector2(bullet_speed,0).rotated(rotation))
		get_tree().get_root().add_child(bullet_instance)
		can_fire=false
		yield(get_tree().create_timer(fire_rate),"timeout")
		can_fire=true
		# ---    стрельба    ----
		
		
	#	var coll = raycast.get_collider()
	#	if raycast.is_colliding() and coll.has_method("kill"):
	#		coll.kill()


