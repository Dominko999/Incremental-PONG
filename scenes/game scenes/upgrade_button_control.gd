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

var level : int = 0
var max_level : int = len(upgrades)

var completed : bool = false

var currency_container : CurrencyContainer

func _ready() -> void:
	tooltip.visible = false
	refresh_button()

func refresh_button():
	if not currency_container:
		currency_container = CurrencyContainer.new(upgrades[level].price)
		labels_container.add_child(currency_container)
	else:
		currency_container.currencies_to_display = upgrades[level].price
		
	fill_tooltip()
	

func check_level():
	if level >= max_level:
		completed = true
		button_mask.disabled = true
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
