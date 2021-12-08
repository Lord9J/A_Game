extends Node2D

export (int) var max_hp=100
export (int) var hp = max_hp setget set_hp


# если значение выше макс. возвращать 100 .если меньше мин .возращать 0
func set_hp(new_hp:int):
	hp=clamp(new_hp,0,100)
	Globals.player_hp=hp
