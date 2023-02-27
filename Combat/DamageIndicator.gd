extends Node2D

onready var number:Label = $Number
onready var animation_player:AnimationPlayer = $AnimationPlayer

func init(pos: Vector2, val: int) -> void:
	$Number.set_text(String(val))
	position = pos
	$AnimationPlayer.play("Spawn")
	yield($AnimationPlayer, "animation_finished")
	queue_free()
