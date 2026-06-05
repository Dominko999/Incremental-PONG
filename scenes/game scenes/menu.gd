extends Scene

@onready var continue_button : Button = %ContinueButton
@onready var new_game_button : Button = %NewGameButton


func _ready() -> void:
	new_game_button.show()
	if GlobalSaveManager.save_exists():
		continue_button.show()
	else:
		continue_button.hide()

func _on_continue_button_button_down() -> void:
	GlobalSaveManager.load_save()
	GlobalSignals.transition_to_upgrade.emit()

func _on_new_game_button_button_down() -> void:
	GlobalSaveManager.create_new_save()
	GlobalSignals.transition_to_upgrade.emit()

func _on_quit_button_button_down() -> void:
	get_tree().quit()
