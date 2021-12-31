extends KinematicBody2D
class_name M_enemy

var player = null

# --- движение ----
var move = Vector2.ZERO
export(int) var speed=50



# --- движение ----


# ----  Инициализирует переменную, как только Узел,   -----
# к которому прикреплен скрипт, а также его дети являются частью дерева сцен.
onready var hp_stat=$health 
onready var ai = $M_AI	
onready var hp_bar=$HPBar
	
# ------------------------------------------
var velocity: Vector2 = Vector2.ZERO


func _ready() ->void:
	ai.initalize(self)
	
	
	yield(get_tree(), "idle_frame")
	var tree = get_tree()
	if tree.has_group("LevelNavigation"):
		ai.levelNavigation = tree.get_nodes_in_group("LevelNavigation")[0]
	if tree.has_group("Player"):
		player = tree.get_nodes_in_group("Player")[0]


	

	
func _process(delta):

	if hp_stat.hp<=0:
		queue_free();



func navigate():	# Define the next position to go to
	if ai.path.size() > 0:
		velocity = global_position.direction_to(ai.path[1]) * speed
		
		# If reached the destination, remove this point from path array
		if global_position == ai.path[0]:
			ai.path.pop_front()


func generate_path():	# It's obvious
	if ai.levelNavigation != null and ai.player != null:
		ai.path = ai.levelNavigation.get_simple_path(global_position, ai.player.global_position, false)


func move():
	velocity = move_and_slide(velocity)




func rotate_toward(location:Vector2):
	rotation=lerp(rotation,global_position.direction_to(location).angle(),0.1)
	print(rotation)
	
func velocity_toward(location:Vector2 )->Vector2:
	return global_position.direction_to(location)*speed

func move_slide():
	return move_and_slide(Vector2(speed,0).rotated(rotation))
	
func anim_walk():
	return 	$AnimatedSprite.play("walk")
	
func anim_idle():
	return 	$AnimatedSprite.play("idle")
	
func anim_attack():
	return 	$AnimatedSprite.play("attack")








#  ============ попал пулей по зомби ================
func _on_HurtBox_area_entered(body):
	if body.is_in_group("Bullet"):
		hp_stat.hp=hp_stat.hp-20
		$HPBar.set_percent_value_int(float(hp_stat.hp)/hp_stat.max_hp*100)

func _on_Trigger_body_exited(body):
	player = null	














