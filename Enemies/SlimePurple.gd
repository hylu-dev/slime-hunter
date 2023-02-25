extends "res://Enemies/Slime.gd"

func take_damage(damage: int) -> void:
	.take_damage(damage)
	scale.x += rng.randf_range(0, .5)
	scale.y += rng.randf_range(0, .5)
	speed += rng.randf_range(0, 25)
