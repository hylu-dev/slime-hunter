class_name Enemy

extends KinematicBody2D

export var health := 1
export var speed := 50
export var acceleration := 2
export var friction := .5
var velocity := Vector2.ZERO
var rng := RandomNumberGenerator.new()

signal enemy_death
	
func init(spawn_position: Vector2) -> void:
	rng.randomize()
	position = spawn_position
	print(self, " spawned at ", position)
	
func take_damage(damage: int) -> void:
	health -= damage
	if health <= 0:
		print(get_child(0), " has died")
		Global.score += 1
		queue_free()
