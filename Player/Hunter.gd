extends KinematicBody2D

export var health := 1
export var speed := 100
export var acceleration := 30
export var friction := 20

signal attacked

var velocity := Vector2.ZERO
var direction := Vector2.ZERO

var screen_size: Vector2

var animation_player: AnimationPlayer
var animation_tree: AnimationTree
var animation_state
var attack_timer: Timer

enum {
	WALK,
	ATTACK
}
var state = WALK

func _ready() -> void:
	screen_size = get_viewport_rect().size
	connect('attacked', $Weapon, '_on_attack_trigger')
	connect('attacked', $HitboxPivot/WeaponHitbox, '_on_attack_trigger')
	animation_player = $AnimationPlayer
	animation_tree = $AnimationTree
	animation_state = animation_tree.get("parameters/playback")
	attack_timer = $AttackTimer
	
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
		
	if direction != Vector2.ZERO:
		animation_state.travel("Walk")
		velocity += direction * acceleration * delta
		velocity = velocity.clamped(speed*delta)
		animation_tree.set("parameters/Idle/blend_position", velocity)
		animation_tree.set("parameters/Walk/blend_position", velocity)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction*delta)
		animation_state.travel("Idle")

	move_and_collide(velocity)
		
#	if (velocity - Vector2.ZERO).length() > 0.001: #velocity may end up as incredibly small float
#		velocity.x = lerp(velocity.x, 0, friction)
#		velocity.y = lerp(velocity.y, 0, friction)
#		position.x = clamp(position.x, 0, screen_size.x)
#		position.y = clamp(position.y, 0, screen_size.y)
#		position += velocity * delta
#		animation_tree.set("parameters/Idle/blend_position", velocity)
#		animation_tree.set("parameters/Walk/blend_position", velocity)
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("attack"):
		emit_signal("attacked")
		$HitboxPivot/WeaponHitbox.enable_hitbox()
		$AnimationPlayer.play("AttackDown")
	if event.is_action_released("attack"):
		$HitboxPivot/WeaponHitbox.disable_hitbox()
	
func take_damage(damage: int) -> void:
	health -= damage
	if health < 1:
		print("Death")
	
	
	
