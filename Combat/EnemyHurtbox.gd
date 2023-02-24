class_name EnemyHurtbox
extends Area2D

func _init() -> void:
	collision_layer = 0
	collision_mask = 3
	
func _ready() -> void:
	connect("area_entered", self, "_on_area_entered")

func _on_area_entered(hitbox: AllyHitbox) -> void:
	if !hitbox:
		return
		
	if owner.has_method("take_damage"):
		print(owner, " took ", hitbox.damage, " damage")
		owner.take_damage(hitbox.damage)
		
	if owner.has_method("knockback"):
		owner.knockback(hitbox.get_parent().global_position)
		
