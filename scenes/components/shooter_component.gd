extends Node2D
class_name ShooterComponent

@export var projectile_scene : PackedScene

func shoot():
	projectile_scene.instantiate()
