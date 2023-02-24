extends Node2D

onready var hitbox = get_child(0).get_node("AllyHitbox/CollisionShape2D")
onready var animation_player = get_child(0).get_node("AnimationPlayer")

func _ready():
	disable_hitbox()

func _on_attack_trigger() -> void:
	animation_player.play("Attack")
	
func enable_hitbox() -> void:
	hitbox.set_disabled(false)
	
func disable_hitbox() -> void:
	hitbox.set_disabled(true)
	
func change_weapon(_weapon: String) -> void:
	pass
