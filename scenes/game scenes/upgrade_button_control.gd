extends Control
class_name UpgradeButtonControl

signal upgrade_requested(button : UpgradeButtonControl)

@export var update_id : String
@export var upgrade_name : String
@export var upgrade_description : String
@export var upgrades : Array[UpgradeData]
@export var next_upgrade_buttons : Array[UpgradeButtonControl]
@export var texture : Texture

var level : int = 0
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
@onready var texture_rect : TextureRect = %TextureRect


func _ready() -> void:
	button_state = GlobalEnums.UpgradeButtonStates.NOT_UPGRADED
	texture_rect.texture = texture
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
	if not button_state == GlobalEnums.UpgradeButtonStates.COMPLETED:
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
	else:
		if currency_container:
			currency_container.queue_free()
		if stat_change_container:
			stat_change_container.queue_free()


func add_completed_label():
	if not completed_label:
		completed_label = Label.new()
		completed_label.text = "COMPLETED"
		completed_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		labels_container.add_child(completed_label)
		


func check_level():
	if level > max_level:
		button_state = GlobalEnums.UpgradeButtonStates.COMPLETED
		button_mask.disabled = true
		add_completed_label()
	refresh_button()


func fill_tooltip():
	name_label.text = upgrade_name
	description_label.text = upgrade_description
	


func upgrade_failed():
	if is_animating:
		return
	is_animating = true
	
	GlobalTweens.shake(self, 20, 0.2)
	await GlobalTweens.flash(self, Color.RED, 0.3)
	
	is_animating = false

func upgrade_success():
	if is_animating:
		return
	is_animating = true
	
	level += 1
	check_level()
	GlobalTweens.scale_up_and_down(self,1.1,1,0.2,0.2)
	await GlobalTweens.flash(self, Color.GREEN, 0.3)
	
	is_animating = false


func _on_upgrade_button_pressed() -> void:
	if button_state != GlobalEnums.UpgradeButtonStates.COMPLETED:
		upgrade_requested.emit(self)


func _on_upgrade_button_mouse_entered() -> void:
	tooltip.visible = true


func _on_upgrade_button_mouse_exited() -> void:
	tooltip.visible = false
