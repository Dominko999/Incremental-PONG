extends Node

@warning_ignore("unused_signal")
signal transition_to_upgrade
@warning_ignore("unused_signal")
signal transition_to_gameplay
@warning_ignore("unused_signal")
signal transition_to_menu

signal upgrade_button_pressed(upgrade : UpgradeData)

@warning_ignore("unused_signal")
signal currency_changed(currency_name : String, amount : int)
