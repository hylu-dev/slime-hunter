class_name EnemyHurtbox
extends Area2D

var damage_indicator := preload("res://Combat/DamageIndicator.tscn")

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
		var indicator_instance = damage_indicator.instance()
		indicator_instance.init(global_position, hitbox.damage)
		get_tree().current_scene.add_child(indicator_instance)
		
	if owner.has_method("knockback"):
		owner.knockback(hitbox.get_parent().global_position)
		
