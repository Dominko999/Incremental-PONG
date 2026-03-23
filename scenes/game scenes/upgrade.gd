extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_play_button_pressed() -> void:
	Global.transition_to_gameplay.emit()


func _on_go_to_menu_button_pressed() -> void:
	Global.transition_to_menu.emit()
