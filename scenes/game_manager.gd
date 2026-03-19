extends Node
class_name GameManager

var current_scene : Scene
@export var gameplay_scene : PackedScene



func _ready() -> void:
	load_scene(gameplay_scene)


func load_scene(scene : PackedScene):
	if current_scene:
		current_scene.queue_free()
	
	current_scene = scene.instantiate()
	add_child(current_scene)
