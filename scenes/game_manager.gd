extends Node
class_name GameManager

var current_scene : Node
@export var gameplay_scene : PackedScene
@export var menu_scene : PackedScene
@export var upgrade_scene : PackedScene



func _ready() -> void:
	load_scene(menu_scene)
	Global.transition_to_gameplay.connect(load_scene.bind(gameplay_scene))
	Global.transition_to_upgrade.connect(load_scene.bind(upgrade_scene))
	Global.transition_to_menu.connect(load_scene.bind(menu_scene))


func load_scene(scene : PackedScene):
	if current_scene:
		current_scene.queue_free()
	
	current_scene = scene.instantiate()
	add_child(current_scene)
