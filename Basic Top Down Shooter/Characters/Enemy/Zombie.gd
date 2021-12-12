extends KinematicBody2D
class_name Zombie

var player = null

# --- движение ----
var move = Vector2.ZERO
export(int) var speed=50
# --- движение ----


# ----  Инициализирует переменную, как только Узел,   -----
# к которому прикреплен скрипт, а также его дети являются частью дерева сцен.
onready var hp_stat=$health 
onready var ai = $AI	
onready var weapon=$Weapon
onready var hp_bar=$HPBar
	
# ------------------------------------------


func _ready() ->void:
	ai.initalize(self,weapon)
	

func _process(delta):

	if hp_stat.hp<=0:
		queue_free();


func rotate_toward(location:Vector2):
	rotation=lerp(rotation,global_position.direction_to(location).angle(),0.1)
	
func velocity_toward(location:Vector2 )->Vector2:
	return global_position.direction_to(location)*speed





# попал пулей по зомби
func _on_HurtBox_area_entered(body):
	if body.is_in_group("Bullet"):
		hp_stat.hp=hp_stat.hp-20
		$HPBar.set_percent_value_int(float(hp_stat.hp)/hp_stat.max_hp*100)

func _on_Trigger_body_exited(body):
	player = null	





