extends Area2D
class_name HitboxComponent

@export var attack := 1
@export var shape := CollisionShape2D


func _on_area_entered(area: Area2D) -> void:
	if area.has_method("damage"):
		area.damage(attack)
		get_parent().queue_free()
