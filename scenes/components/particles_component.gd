extends Node2D

@export var particle_explosion : PackedScene


func _on_health_component_on_death() -> void:
	if particle_explosion != null:
		var explosion = particle_explosion.instantiate()
		explosion.global_position = global_position
		get_tree().current_scene.add_child(explosion)
