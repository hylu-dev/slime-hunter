class_name Enemy

extends KinematicBody2D

export var health := 1
export var speed := 50
export var acceleration := 2
export var friction := .5
export var knockback := 300

var velocity := Vector2.ZERO
var knockback_vector = Vector2.ZERO
var rng := RandomNumberGenerator.new()

onready var hit_particles:Particles2D = $HitParticles

signal enemy_death
	
func init(spawn_position: Vector2) -> void:
	rng.randomize()
	position = spawn_position
	
func take_damage(damage: int) -> void:
	health -= damage
	$AnimationPlayer.play("Hit")
	if health <= 0:
		Engine.time_scale = 0.6
		yield( get_node("AnimationPlayer"), "animation_finished" )
		Engine.time_scale = 1
		Global.score += 1
		queue_free()
		
	yield( get_node("AnimationPlayer"), "animation_finished" )
	$AnimationPlayer.play("Move")
		
func knockback(source_position: Vector2) -> void:
	hit_particles.rotation = abs(get_angle_to(source_position)) + PI
	print(get_angle_to(source_position))
	hit_particles.restart()
	knockback_vector = -position.direction_to(source_position)*knockback
	move_and_slide(source_position)
	
func _physics_process(delta: float) -> void:
	knockback_vector = lerp(knockback_vector, Vector2.ZERO, delta*10)
	move_and_slide(knockback_vector)
