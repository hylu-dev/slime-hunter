extends Control

var rng = RandomNumberGenerator.new()
onready var screen_size := get_viewport_rect().size
onready var spawn_timer:Timer = $SpawnTimer
export var difficulty_curve: Curve = Curve.new()
export var spawn_growth:float = 120.0 # reaches max spawn rate after a minute
var spawn_rates:Array = []

var enemies := [
	preload("res://Enemies/SlimeGreen.tscn"),
	preload("res://Enemies/SlimeRed.tscn"),
	preload("res://Enemies/SlimePurple.tscn"),
	preload("res://Enemies/SlimeCyan.tscn")
]

func _ready() -> void:
	rng.randomize()
	_init_spawn_rates()
	spawn_timer.connect('timeout', self, '_on_timeout')
	
func _init_spawn_rates() -> void :
	for enemy in enemies:
		var instance = enemy.instance()
		spawn_rates.append(instance.get_spawn_chance())
		instance.queue_free()
	
func _get_random_enemy() -> Enemy:
	randomize()
	var sum_rates = 0
	for rate in spawn_rates: sum_rates += rate
	var enemy_id = 0
	# Rejection sampling, inefficient but works. To improve look to other methods such as Alias
	while true:
		enemy_id = randi() % enemies.size()
		var u = sum_rates*randf()
		if u <= spawn_rates[enemy_id]: break
		
	return enemies[enemy_id].instance()

func _on_timeout():
	var enemy:Enemy = _get_random_enemy()
	var spawn_direction = rng.randi_range(0, 3)
	var rand_pos = Vector2(rng.randi_range(0, screen_size.x), 
		rng.randi_range(0, screen_size.y))
	var spawn_position = Vector2.ZERO
	match spawn_direction:
		0:
			spawn_position = Vector2(rand_pos.x, -50)
		1:
			spawn_position = Vector2(rand_pos.x, screen_size.y+50)
		2:
			spawn_position = Vector2(-50, rand_pos.y)
		3:
			spawn_position = Vector2(screen_size.x+50, rand_pos.y)
	enemy.init(spawn_position)
	get_tree().current_scene.add_child(enemy)
	
	spawn_timer.start(rng.randf_range(
		difficulty_curve.interpolate(Global.game_time/spawn_growth),
		difficulty_curve.interpolate(Global.game_time/spawn_growth)/2.0
	))
	
