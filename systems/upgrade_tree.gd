extends Control

@export var starting_buttons : Array[UpgradeButtonControl]


func _ready() -> void:
	for child in get_children():
		if child is UpgradeButtonControl:
			child.upgrade_requested.connect(_on_button_upgrade_requested)
			child.set_state(GlobalEnums.UpgradeButtonStates.HIDDEN)

	for button in starting_buttons:
		button.set_state(GlobalEnums.UpgradeButtonStates.NOT_UPGRADED)


func _process(_delta : float) -> void:
	pivot_offset = size / 2
	if Input.is_action_just_pressed("ui_zoom_out"):
		self.scale *= Vector2(0.9,0.9)
	elif Input.is_action_just_pressed("ui_zoom_in"):
		self.scale *= Vector2(1.1,1.1)


func _on_button_upgrade_requested(button: UpgradeButtonControl) -> void:
	var current_upgrade_data = button.upgrades[button.level]

	if _can_afford(current_upgrade_data.price):
		
		button.upgrade_success()
		
		GlobalSignals.upgrade_to_apply.emit(current_upgrade_data)
		
		_unlock_next_nodes(button)
	else:
		button.upgrade_failed()


func _can_afford(price: Dictionary) -> bool:
	for currency in price:
		var cost = price[currency]
		if GlobalGameStats.currency_data_dictionary[currency].amount_available < cost:
			return false
	return true


func _unlock_next_nodes(parent_button: UpgradeButtonControl) -> void:
	for next_button in parent_button.next_upgrade_buttons:
		if next_button.button_state == GlobalEnums.UpgradeButtonStates.HIDDEN:
			next_button.set_state(GlobalEnums.UpgradeButtonStates.NOT_UPGRADED)
