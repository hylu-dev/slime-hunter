class_name AllyHitbox
extends Area2D

export var damage := 1

func _init() -> void:
	collision_layer = 3
	collision_mask = 0
	
func set_damage(value: int) -> void:
	damage = value
