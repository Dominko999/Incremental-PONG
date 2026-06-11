extends Scene

@onready var continue_button : Button = %ContinueButton
@onready var new_game_button : Button = %NewGameButton
@onready var crown : Sprite2D = %Crown

func _ready() -> void:
	new_game_button.show()
	if GlobalSaveManager.save_exists():
		GlobalSaveManager.load_save()
		GlobalGameStats.load_currency()
		GlobalGameStats.load_stats()
		GlobalGameStats.load_abilities()
		continue_button.show()
	else:
		continue_button.hide()
	
	if GlobalGameStats.is_ability_unlocked(GlobalEnums.Abilities.CHAMPION):
		crown.show()
	else:
		crown.hide()


func _on_continue_button_pressed() -> void:
	GlobalSaveManager.load_save()
	GlobalGameStats.load_currency()
	GlobalGameStats.load_stats()
	GlobalGameStats.load_abilities()
	GlobalSignals.transition_to_upgrade.emit()


func _on_new_game_button_pressed() -> void:
	GlobalGameStats.purge_currency()
	GlobalGameStats.purge_stats()
	GlobalGameStats.purge_abilities()
	GlobalSaveManager.create_new_save()
	GlobalSignals.transition_to_upgrade.emit()


func _on_quit_button_pressed() -> void:
	get_tree().quit()
