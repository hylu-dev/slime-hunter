extends Node

var elapsed_time = 0
onready var game_timer:Timer = $GameTimer
onready var game_time:Label = $Canvas/GameTime
onready var score:Label = $Canvas/Score

func _ready() -> void:
	game_timer.connect("timeout", self, "_update_time")

func _process(delta: float) -> void:
	score.set_text(String(Global.score))

func _update_time() -> void:
	elapsed_time += 1
	game_time.set_text(String(elapsed_time))
