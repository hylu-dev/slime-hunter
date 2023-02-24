extends Enemy

func _ready() -> void:
	health = 1
	speed = 25
	$AnimationPlayer.play("Move")

func _enter_tree() -> void:
	var screen_size = get_viewport_rect().size
	var rand_target = Vector2(rng.randi_range(0, screen_size.x), rng.randi_range(0, screen_size.y))
	velocity = position.direction_to(rand_target).normalized()
	if velocity.x < 0:
		self.scale.x *= -1

func _physics_process(delta: float) -> void:
	move_and_slide(velocity * speed)
