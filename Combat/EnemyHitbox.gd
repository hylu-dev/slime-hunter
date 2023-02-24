class_name EnemyHitbox

extends Area2D

export var damage := 1

func _init() -> void:
	collision_layer = 2
	collision_mask = 0
