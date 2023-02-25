extends Control

var rng = RandomNumberGenerator.new()
onready var screen_size := get_viewport_rect().size
onready var spawn_timer:Timer = $SpawnTimer
var enemies := [
	preload("res://Enemies/SlimeGreen.tscn"),
	preload("res://Enemies/SlimeRed.tscn"),
	preload("res://Enemies/SlimePurple.tscn"),
	preload("res://Enemies/SlimeCyan.tscn")
]

export var spawn_interval:float = 3

func _ready() -> void:
	rng.randomize()
	$SpawnTimer.connect('timeout', self, '_on_timeout')

# Called when the node enters the scene tree for the first time.
func _on_timeout():
	var EnemyPreload = enemies[randi() % enemies.size()]
	var enemy:Enemy = EnemyPreload.instance()
	
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
	
	spawn_timer.start(rng.randf_range(0, spawn_interval))
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
