extends Node2D
class_name ShooterComponent

@export var projectile_scene : PackedScene

func shoot():
	var projectile = projectile_scene.instantiate()
	add_child(projectile)
