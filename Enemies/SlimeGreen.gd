extends Enemy

onready var animation_player: AnimationPlayer = $AnimationPlayer
onready var animated_sprite: AnimatedSprite = $AnimatedSprite

onready var screen_size = get_viewport_rect().size

func _ready() -> void:
	animation_player.play("Move")
	var rand_target = Vector2(rng.randi_range(0, screen_size.x), rng.randi_range(0, screen_size.y))
	velocity = position.direction_to(rand_target).normalized()
	if velocity.x < 0:
		animated_sprite.scale.x *= -1

func _physics_process(delta: float) -> void:
	move_and_slide(velocity * speed)
