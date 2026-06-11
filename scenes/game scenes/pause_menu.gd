extends Control
class_name PauseMenu

var game_paused : bool = false



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()
	get_tree().paused = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		if game_paused:
			resume_game()
		else:
			pause_game()

func pause_game() -> void:
	show()
	get_tree().paused = true
	
	
func resume_game() -> void:
	hide()
	get_tree().paused = false
	

func _on_resume_button_pressed() -> void:
	resume_game()


func _on_quit_button_pressed() -> void:
	get_tree().paused = false
	GlobalSignals.transition_to_upgrade.emit()
