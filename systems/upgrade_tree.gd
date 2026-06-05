extends Control

@export var starting_buttons : Array[UpgradeButtonControl]
@export var unfinished_line_gradient : Gradient

var is_dragging : bool = false
var target_position : Vector2
var target_scale : Vector2

func _ready() -> void:
	target_position = position
	target_scale = scale
	mouse_filter = Control.MOUSE_FILTER_STOP
	
	for child in get_children():
		if child is UpgradeButtonControl:
			child.upgrade_requested.connect(_on_button_upgrade_requested)
			
			if GlobalSaveManager.save_file:
				var saved_level = GlobalSaveManager.save_file.upgrade_levels.get(child.upgrade_id)
				
				if saved_level != null:
					child.level = GlobalSaveManager.save_file.upgrade_levels[child.upgrade_id]
					if child.level != 0:
						_unlock_next_nodes(child)
						show_unfinished_lines(child)
				else:
					child.set_state(GlobalEnums.UpgradeButtonStates.HIDDEN)
			

	for button in starting_buttons:
		button.set_state(GlobalEnums.UpgradeButtonStates.NOT_UPGRADED)
		show_unfinished_lines(button)


func save_button_levels() -> void:
	var upgrade_levels_dict : Dictionary = {}
	
	for child in get_children():
		if child is UpgradeButtonControl:
			upgrade_levels_dict[child.upgrade_id] = child.level
	GlobalSaveManager.save_file.upgrade_levels = upgrade_levels_dict


func _process(delta : float) -> void:
	pivot_offset = size / 2
	if Input.is_action_just_pressed("ui_zoom_out"):
		target_scale *= Vector2(0.9, 0.9)
	elif Input.is_action_just_pressed("ui_zoom_in"):
		target_scale *= Vector2(1.1, 1.1)
	
	scale = scale.lerp(target_scale, 15.0 * delta)
	position = position.lerp(target_position, 15.0 * delta)


func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				is_dragging = true
			else:
				is_dragging = false
	elif event is InputEventMouseMotion:
		if is_dragging:
			target_position += event.relative * scale


func _on_button_upgrade_requested(button: UpgradeButtonControl) -> void:
	var current_upgrade_data = button.upgrades[button.level]

	if _can_afford(current_upgrade_data.price):
		
		GlobalSignals.upgrade_to_apply.emit(current_upgrade_data)
		
		button.upgrade_success()
		
		_unlock_next_nodes(button)
		
		save_button_levels()
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
		var line = Line2D.new()
		var line_start : Vector2 = parent_button.position + (parent_button.size / 2)
		var line_end : Vector2 = next_button.position + (next_button.size / 2)
		line.add_point(line_start)
		line.add_point(line_end)
		line.width = 5
		line.z_index = -1
		add_child(line)
		if next_button.button_state == GlobalEnums.UpgradeButtonStates.HIDDEN:
			next_button.set_state(GlobalEnums.UpgradeButtonStates.NOT_UPGRADED)
			show_unfinished_lines(next_button)


func show_unfinished_lines(button : UpgradeButtonControl):
	for next_button in button.next_upgrade_buttons:
		var unfinished_line = Line2D.new()
		var start = button.position + (button.size / 2)
		var end = next_button.position + (next_button.size / 2)
		unfinished_line.add_point(start)
		unfinished_line.add_point(end)
		unfinished_line.width = 5
		unfinished_line.z_index = -1
		unfinished_line.gradient = unfinished_line_gradient
		add_child(unfinished_line)
