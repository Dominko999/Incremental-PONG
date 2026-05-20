extends Node2D

@onready var player_currency_container : CurrencyContainer = %CurrencyContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player_currency_container.is_player_currency_display = true
	player_currency_container._update_display()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_play_button_pressed() -> void:
	GlobalSignals.transition_to_gameplay.emit()


func _on_go_to_menu_button_pressed() -> void:
	GlobalSignals.transition_to_menu.emit()
