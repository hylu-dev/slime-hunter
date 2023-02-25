extends KinematicBody2D

export var health := 1
export var speed := 100
export var acceleration := 30
export var friction := 20
export var attack_cooldown := 1

signal attacked

var velocity := Vector2.ZERO
var direction := Vector2.ZERO

var screen_size: Vector2

onready var animation_player: AnimationPlayer = $AnimationPlayer
onready var animation_tree: AnimationTree = $AnimationTree
onready var animation_state
onready var attack_timer: Timer = $AttackTimer
onready var grass_particles: Particles2D = $Weapon/GrassParticles

var movement_enabled: bool = true

enum {
	WALK,
	ATTACK
}
var state = WALK

func _ready() -> void:
	screen_size = get_viewport_rect().size
	connect('attacked', $HitboxPivot/WeaponHitbox, '_on_attack_trigger')
	attack_timer.connect('timeout', self, '_attack_ready')
	animation_state = animation_tree.get("parameters/playback")
	
func _physics_process(delta: float) -> void:
	match state:
		WALK:
			walk_state(delta)
		_:
			pass
	
func walk_state(delta: float):
	var direction := Vector2.ZERO
	if Input.is_action_pressed("move_left"):
		direction.x = -1
	elif Input.is_action_pressed("move_right"):
		direction.x = 1
	if Input.is_action_pressed("move_up"):
		direction.y = -1
	elif Input.is_action_pressed("move_down"):
		direction.y = 1
	direction = direction.normalized()
	
	if Input.is_action_pressed("run"):
		speed = 200
	else:
		speed = 100
		
	if direction != Vector2.ZERO and movement_enabled:
		animation_state.travel("Walk")
		velocity += direction * acceleration * delta
		velocity = velocity.clamped(speed*delta)
		animation_tree.set("parameters/Idle/blend_position", velocity)
		animation_tree.set("parameters/Walk/blend_position", velocity)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction*delta)
		animation_state.travel("Idle")

	move_and_collide(velocity)
	_enforce_bounds()
	_emit_grass_particles()
	
func _emit_grass_particles() -> void:
	if animation_state.get_current_node() == "Walk":
		grass_particles.set_emitting(true)
	else:
		grass_particles.set_emitting(false)

func _enforce_bounds() -> void: 
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("attack") and attack_timer.is_stopped():
		emit_signal("attacked")
		attack_timer.start(attack_cooldown)
		$HitboxPivot/WeaponHitbox.enable_hitbox()
		animation_player.play("AttackDown")
		movement_enabled = false;
		yield(animation_player, "animation_finished")
		movement_enabled = true;
		$HitboxPivot/WeaponHitbox.disable_hitbox()
		
func _attack_ready() -> void:
	print("attack ready")
	
func take_damage(damage: int) -> void:
	health -= damage
	if health < 1:
		print("Death")
	
	
	
