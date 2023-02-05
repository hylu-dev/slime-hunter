extends Node2D

export var speed = 400
export var acceleration = 2
export var friction = .5
var velocity = Vector2.ZERO
var direction = -PI/2 # start facing up
var screen_size

func _ready():
	screen_size = get_viewport_rect().size
	
func _process(delta):	
	if Input.is_action_pressed("move_left"):
		velocity.x = lerp(velocity.x, -speed, acceleration)
		direction = velocity.angle()
	elif Input.is_action_pressed("move_right"):
		velocity.x = lerp(velocity.x, speed, acceleration)
		direction = velocity.angle()
	if Input.is_action_pressed("move_up"):
		velocity.y = lerp(velocity.y, -speed, acceleration)
		direction = velocity.angle()
	elif Input.is_action_pressed("move_down"):
		velocity.y = lerp(velocity.y, speed, acceleration)
		direction = velocity.angle()
		
	if Input.is_action_pressed("run"):
		speed = 700
	else:
		speed = 400

	velocity.x = lerp(velocity.x, 0, friction)
	velocity.y = lerp(velocity.y, 0, friction)
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
	position += velocity * delta

	$Sprite.rotation = lerp_angle($Sprite.rotation, direction+PI/2, 0.3)
	
	
	
