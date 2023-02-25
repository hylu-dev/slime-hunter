extends "res://Enemies/Slime.gd"

func take_damage(damage: int) -> void:
	.take_damage(damage)
	speed *= .5
