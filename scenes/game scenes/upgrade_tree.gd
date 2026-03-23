extends Scene

@export var gameplay_scene : PackedScene



func _on_play_button_button_down() -> void:
	Global.transition_to_upgrade.emit()


func _on_quit_button_button_down() -> void:
	get_tree().quit()
