extends KinematicBody2D


var player = null

# --- движение ----
var move = Vector2.ZERO
# --- движение ----


# ----  Инициализирует переменную, как только Узел,   -----
# к которому прикреплен скрипт, а также его дети являются частью дерева сцен.
onready var hp_stat=$Health 
onready var ai = $AI	
	
# ------------------------------------------


#func _physics_process(delta):
	

	



func set_player(p):
	player = p


# попал пулей по зомби
func _on_HurtBox_area_entered(body):
	if body.is_in_group("bullet"):
		hp_stat.hp=hp_stat.hp-15
		$HPBar.set_percent_value_int(float(hp_stat.hp)/hp_stat.max_hp*100)
		if hp_stat.hp<=0:
		 queue_free()



func _on_Trigger_body_exited(body):
	player = null	

func _on_Timer_timeout():
	print("пытаюсь стрелять")
	if player !=null:
		fire()
	
func fire():
	pass
