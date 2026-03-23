extends Control
class_name UpgradeButtonControl

@export var upgrade_data : UpgradeData

@onready var button : Button = $UpgradeButton



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_upgrade_button_mouse_entered() -> void:
	pass # Replace with function body.


func _on_upgrade_button_pressed() -> void:
	Global.upgrade_button_pressed.emit(upgrade_data)
