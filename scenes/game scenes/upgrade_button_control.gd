extends Control
class_name UpgradeButtonControl

@export var upgrade_name : String
@export var upgrade_description : String
@export var upgrades : Array[UpgradeData]

@onready var button_mask : Button = %UpgradeButtonMask
@onready var tooltip : Control = %Tooltip
@onready var name_label : Label = %UpgradeNameLabel
@onready var description_label : Label = %UpgradeDescriptionLabel
@onready var labels_container : VBoxContainer = %LabelsContainer

@export var next_upgrade_buttons : Array[UpgradeButtonControl]

var level : int = 0
var max_level : int 

var button_state : GlobalEnums.UpgradeButtonStates

var currency_container : CurrencyContainer
var completed_label : Label

func _ready() -> void:
	button_state = GlobalEnums.UpgradeButtonStates['HIDDEN']
	max_level = len(upgrades) - 1
	tooltip.visible = false
	refresh_button()
	apply_button_state()

func apply_button_state():
	match button_state:
		GlobalEnums.UpgradeButtonStates['HIDDEN']:
			hide()
		GlobalEnums.UpgradeButtonStates['NOT_UPGRADED']:
			modulate = Color.GRAY
		GlobalEnums.UpgradeButtonStates['UPGRADED']:
			modulate = Color.BLUE
		GlobalEnums.UpgradeButtonStates['COMPLETED']:
			modulate = Color.GOLD


func refresh_button():
	if not button_state == GlobalEnums.UpgradeButtonStates['COMPLETED']:
		if not currency_container:
			currency_container = CurrencyContainer.new(upgrades[level].price)
			labels_container.add_child(currency_container)
		else:
			currency_container.currencies_to_display = upgrades[level].price
		fill_tooltip()
	else:
		if currency_container:
			currency_container.queue_free()

func add_completed_label():
	if not completed_label:
		completed_label = Label.new()
		completed_label.text = "COMPLETED"
		labels_container.add_child(completed_label)

func check_level():
	if level > max_level:
		button_state = GlobalEnums.UpgradeButtonStates["COMPLETED"]
		button_mask.disabled = true
		add_completed_label()
	refresh_button()

func fill_tooltip():
	name_label.text = upgrade_name
	description_label.text = upgrade_description
	

func try_upgrade(upgrade_data : UpgradeData):
	for currency in upgrade_data.price:
		var cost = upgrade_data.price[currency]
		if GlobalGameStats.currency_data_dictionary[currency].amount_available < cost:
			on_upgrade_failed()
			return
	
	on_upgrade_succeded()

func on_upgrade_failed():
	modulate = Color.RED

func on_upgrade_succeded():
	modulate = Color.GREEN
	Global.upgrade_to_apply.emit(upgrades[level])
	level += 1
	check_level()

func _on_upgrade_button_pressed() -> void:
	try_upgrade(upgrades[level])


func _on_upgrade_button_mouse_entered() -> void:
	tooltip.visible = true


func _on_upgrade_button_mouse_exited() -> void:
	tooltip.visible = false
