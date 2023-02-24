extends Node

func _process(delta: float) -> void:
	$Score.set_text(String(Global.score))
