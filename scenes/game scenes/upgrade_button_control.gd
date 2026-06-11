extends Control
class_name UpgradeButtonControl

signal upgrade_requested(button : UpgradeButtonControl)

@export var upgrade_id : String
@export var upgrade_name : String
@export var upgrade_description : String
@export var upgrades : Array[UpgradeData]
@export var next_upgrade_buttons : Array[UpgradeButtonControl]
@export var texture : Texture

@export var full_level_panel_theme : StyleBoxFlat
@export var empty_level_panel_theme : StyleBoxFlat

@export var ability_upgrade_theme : Theme

var level : int = 0:
	set(value):
		level = value
		check_level()
var max_level : int 
var button_state : GlobalEnums.UpgradeButtonStates
var currency_container : CurrencyContainer
var stat_change_container : StatChangeContainer
var completed_label : Label
var is_animating : bool = false

@onready var button_mask : Button = %UpgradeButtonMask
@onready var tooltip : Control = %Tooltip
@onready var name_label : Label = %UpgradeNameLabel
@onready var description_label : Label = %UpgradeDescriptionLabel
@onready var labels_container : VBoxContainer = %LabelsContainer
@onready var level_container : HBoxContainer = %LevelHBoxContainer
@onready var click_successfull_audio_player : AudioStreamPlayer = %ClickSuccessfullAudioPlayer
@onready var click_failed_audio_player : AudioStreamPlayer = %ClickFailedAudioPlayer

func _ready() -> void:
	if upgrades != null and upgrades[0].ability_to_unlock != -1:
		button_mask.theme = ability_upgrade_theme
	button_state = GlobalEnums.UpgradeButtonStates.NOT_UPGRADED
	button_mask.icon = texture
	max_level = len(upgrades) - 1
	tooltip.visible = false
	refresh_button()
	apply_button_state()


func set_state(new_state : GlobalEnums.UpgradeButtonStates) -> void:
	button_state = new_state
	apply_button_state()
	refresh_button()


func apply_button_state():
	match button_state:
		GlobalEnums.UpgradeButtonStates.HIDDEN:
			hide()
			button_mask.disabled = true
		GlobalEnums.UpgradeButtonStates.NOT_UPGRADED:
			show()
			modulate = Color.GRAY
			button_mask.disabled = false
		GlobalEnums.UpgradeButtonStates.UPGRADED:
			show()
			button_mask.disabled = false
		GlobalEnums.UpgradeButtonStates.COMPLETED:
			show()
			button_mask.disabled = true


func refresh_button():
	apply_button_state()
	if button_state == GlobalEnums.UpgradeButtonStates.COMPLETED or level >= upgrades.size():
		if currency_container:
			currency_container.queue_free()
		if stat_change_container:
			stat_change_container.queue_free()
		update_level_container()
		return
		
	if not stat_change_container:
		stat_change_container = StatChangeContainer.new(upgrades[level])
		labels_container.add_child(stat_change_container)
	else:
		stat_change_container.upgrade_data = upgrades[level]
		
	if not currency_container:
		currency_container = CurrencyContainer.new(upgrades[level].price)
		labels_container.add_child(currency_container)
	else:
		currency_container.currencies_to_display = upgrades[level].price
		
	fill_tooltip()
	update_level_container()


func add_completed_label():
	if not completed_label:
		completed_label = Label.new()
		completed_label.text = "COMPLETED"
		completed_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		labels_container.add_child(completed_label)


func check_level():
	if level > 0:
		button_state = GlobalEnums.UpgradeButtonStates.UPGRADED
	if level > max_level:
		button_state = GlobalEnums.UpgradeButtonStates.COMPLETED
		button_mask.disabled = true
		add_completed_label()
	refresh_button()


func update_level_container() -> void:
	for child in level_container.get_children():
		child.queue_free()
	
	for i in range(0, level):
		var full_panel = PanelContainer.new()
		full_panel.add_theme_stylebox_override("panel", full_level_panel_theme)
		full_panel.custom_minimum_size = Vector2(30.0, 30.0)
		level_container.add_child(full_panel)
	
	for i in range(level, max_level + 1):
		var empty_panel = PanelContainer.new()
		empty_panel.add_theme_stylebox_override("panel", empty_level_panel_theme)
		empty_panel.custom_minimum_size = Vector2(30.0, 30.0)
		level_container.add_child(empty_panel)


func fill_tooltip():
	name_label.text = upgrade_name
	description_label.text = upgrade_description


func upgrade_failed():	
	if is_animating:
		return
	is_animating = true
	
	if not click_failed_audio_player.playing:
		click_failed_audio_player.play()
	
	GlobalTweens.shake(self, 20, 0.2)
	await GlobalTweens.flash(self, Color.RED, 0.3)
	
	is_animating = false


func upgrade_success():
	if is_animating:
		return
	is_animating = true
	
	if not click_successfull_audio_player.playing:
		click_successfull_audio_player.play()
	
	level += 1
	check_level()
	GlobalTweens.scale_up_and_down(self,1.1,1,0.2,0.2)
	await GlobalTweens.flash(self, Color.GREEN, 0.3)
	
	is_animating = false


func _on_upgrade_button_pressed() -> void:
	if is_animating:
		return
	if button_state != GlobalEnums.UpgradeButtonStates.COMPLETED:
		upgrade_requested.emit(self)


func _on_upgrade_button_mouse_entered() -> void:
	tooltip.visible = true


func _on_upgrade_button_mouse_exited() -> void:
	tooltip.visible = false
