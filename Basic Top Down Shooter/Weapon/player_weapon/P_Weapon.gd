extends Node2D




export var Bullet : PackedScene


export(int) var ammo: int 

onready var end_gun=$EndGun
onready var gun_direction=$GunDirection
onready var attack_cooldown=$AttackCooldown
onready var animation_player=$AnimationPlayer
onready var reload=$reload

var gilse = load("res://Presets/gilse.tscn")



func shoot():
	
	if attack_cooldown.is_stopped() and Bullet!=null and reload.is_stopped():
			if Globals.player_ammo>0:	
				Globals.player_ammo-=1
				var bullet_instance=Bullet.instance()
				var direction = (gun_direction.global_position - end_gun.global_position).normalized()
				GlobalSignals.emit_signal("bullet_fired",bullet_instance,end_gun.global_position,direction)
				attack_cooldown.start()
				animation_player.play("muzzle_flash")
				animation_player.play("flashing")
				
				
				var blood_instance=gilse.instance()
				get_tree().current_scene.add_child(blood_instance)
				blood_instance.global_position=global_position
				blood_instance.rotation=global_position.angle_to_point(Globals.player.global_position)+45
				

			else:
				reload.start()
				


func _on_reload_timeout():
	Globals.player_ammo=ammo
