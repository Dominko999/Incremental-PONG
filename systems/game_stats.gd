extends Node
class_name GameStats

var round_duration : float = 20.0
var ball_damage : int = 1
var paddle_speed : float = 300
var enemies_spawn_rate : float = 1
var money_multiplier : float = 1

var currency_data_dictionary : Dictionary  # przechowywuje ilość wszystkich walut, jakie ma gracz

@onready var blue_currency : CurrencyData = preload("res://currency/blue_currency_data.tres")

func _ready() -> void:
	currency_data_dictionary[blue_currency.type] = blue_currency
	Global.upgrade_button_pressed.connect(try_upgrade)

func add_currency(currency : CurrencyData, amount : int):
	currency_data_dictionary[currency.type].amount_available += amount
	emit_signal("Global.currency_changed", currency.type, amount)

func try_upgrade(upgrade_data):
	for currency in upgrade_data.price:
		var cost = upgrade_data.price[currency]
		if currency_data_dictionary[currency].amount_available >= cost:
			pass
	
