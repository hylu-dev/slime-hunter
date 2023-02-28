extends Node

onready var game_timer:Timer = $GameTimer
onready var game_time:Label = $HUD/GameTime
onready var score:Label = $HUD/Score
onready var hunter:KinematicBody2D = $Hunter
onready var camera:Camera2D = $Camera2D
onready var background:TextureRect = $Background
onready var HUD:CanvasLayer = $HUD
onready var game_over_canvas:CanvasLayer = $GameOverCanvas
onready var animation_player:AnimationPlayer = $AnimationPlayer
onready var pause_canvas:CanvasLayer = $PauseCanvas

var game_over:bool = false


func _ready() -> void:
	game_timer.connect("timeout", self, "_update_time")
	hunter.connect('death', self, '_on_death')
	game_over_canvas.get_node("RestartButton").connect("button_up", self, 'reload_game')

func _process(delta: float) -> void:
	
	camera.position = camera.position.linear_interpolate(hunter.position, .1)
	camera.zoom = camera.zoom.linear_interpolate(Vector2(.7, .7), .05)
	
	if game_over:
		_game_over()
		
func reload_game() -> void:
	Engine.time_scale = 1
	get_tree().reload_current_scene()

func _update_time() -> void:
	Global.game_time += 1
	game_time.set_text(String(Global.game_time))

func _on_death() -> void:
	Engine.time_scale = .3
	animation_player.play("GameOver")
	game_over = true
	HUD.visible = false
	game_over_canvas.visible = true
	hunter.set_physics_process(false)
	hunter.attack_enabled = false

func _game_over() -> void:
	camera.position = camera.position.linear_interpolate(hunter.position, .1)
	camera.zoom = camera.zoom.linear_interpolate(Vector2(.5, .5), .05)
	
func pause_game() -> void:
	if pause_canvas.visible:
		Engine.time_scale = 1;
		pause_canvas.visible = false
	else:
		Engine.time_scale = 0;
		pause_canvas.visible = true
	
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause") and not game_over:
		pause_game()
	
	
	
