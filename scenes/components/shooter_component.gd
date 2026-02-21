extends Node2D
class_name ShooterComponent

@export var projectile_scene : PackedScene
@export var projectiles_parent_group : String = "projectiles_parent"

var projectile_node : Node

func _ready() -> void:
	projectile_node = get_tree().get_first_node_in_group(projectiles_parent_group)

func shoot():
	var projectile = projectile_scene.instantiate()
	
	projectile_node.add_child(projectile)
	projectile.global_position = global_position
