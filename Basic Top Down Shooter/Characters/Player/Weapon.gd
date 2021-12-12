extends Node2D
class_name Weapon



export var Bullet : PackedScene


onready var end_gun=$EndGun
onready var gun_direction=$GunDirection
onready var attack_cooldown=$AttackCooldown
onready var animation_player=$AnimationPlayer

func shoot():
	
	if attack_cooldown.is_stopped() and Bullet!=null:
			var bullet_instance=Bullet.instance()
			var direction = (gun_direction.global_position - end_gun.global_position).normalized()
			GlobalSignals.emit_signal("bullet_fired",bullet_instance,end_gun.global_position,direction)
			attack_cooldown.start()
		#	animation_player.play("muzzle_flash")
