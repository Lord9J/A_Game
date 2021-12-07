extends KinematicBody2D


var player = null

# --- движение ----
var move = Vector2.ZERO
export(int) var speed=50
# --- движение ----


# ----  Инициализирует переменную, как только Узел,   -----
# к которому прикреплен скрипт, а также его дети являются частью дерева сцен.
onready var hp_stat=$Health 
onready var ai = $AI	
onready var weapon=$Weapon

	
# ------------------------------------------


func _ready() ->void:
	ai.initalize(self,weapon)

func rotate_toward(location:Vector2):
	rotation=lerp(rotation,global_position.direction_to(location).angle(),0.1)
	
func velocity_toward(location:Vector2 )->Vector2:
	return global_position.direction_to(location)*speed





# попал пулей по зомби
func _on_HurtBox_area_entered(body):
	if body.is_in_group("bullet"):
		hp_stat.hp=hp_stat.hp-15
		$HPBar.set_percent_value_int(float(hp_stat.hp)/hp_stat.max_hp*100)
		if hp_stat.hp<=0:
		 queue_free()



func _on_Trigger_body_exited(body):
	player = null	
