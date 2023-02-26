extends "res://Enemies/Slime.gd"

func take_damage(damage: int) -> void:
	.take_damage(damage)
	scale.x *= .8
	scale.y *= .8
	speed += 10
	knockback += 50
