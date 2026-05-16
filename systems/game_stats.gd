extends Node
class_name GameStats

var round_duration : Stat = Stat.new(20.0)
var ball_damage : Stat = Stat.new(1.0)
var paddle_speed : Stat = Stat.new(500.0)
var enemies_spawn_rate : Stat = Stat.new(1.0)
var money_multiplier : Stat = Stat.new(1.0)

var currency_data_dictionary : Dictionary  # przechowywuje dane wszystkich walut, jakie ma gracz

@onready var blue_currency : CurrencyData = preload("res://currency/blue_currency_data.tres")
@onready var red_currency : CurrencyData = preload("res://currency/red_currency_data.tres")
func _ready() -> void:
	currency_data_dictionary[blue_currency.type] = blue_currency
	currency_data_dictionary[red_currency.type] = red_currency
	Global.upgrade_to_apply.connect(apply_upgrade)

func add_currency(currency : CurrencyData, amount : int):
	currency_data_dictionary[currency.type].amount_available += amount
	Global.emit_signal("currency_changed", currency.type, amount)

func try_upgrade(upgrade_data : UpgradeData):
	for currency in upgrade_data.price:
		var cost = upgrade_data.price[currency]
		if currency_data_dictionary[currency].amount_available < cost:
			return
	apply_upgrade(upgrade_data)

func apply_upgrade(upgrade_data : UpgradeData):
	for currency in upgrade_data.price:
		var cost = upgrade_data.price[currency]
		currency_data_dictionary[currency].amount_available -= cost
	for upgrade in upgrade_data.stats:
		match upgrade:
			UpgradeData.stats_list.ROUND_DURATION:
				apply_operation(round_duration, upgrade_data, upgrade)
			UpgradeData.stats_list.BALL_DAMAGE:
				apply_operation(ball_damage, upgrade_data, upgrade)
			UpgradeData.stats_list.PADDLE_SPEED:
				apply_operation(paddle_speed, upgrade_data, upgrade)
			UpgradeData.stats_list.ENEMIES_SPAWN_RATE:
				apply_operation(enemies_spawn_rate, upgrade_data, upgrade)
			UpgradeData.stats_list.MONEY_MULTIPLIER:
				apply_operation(money_multiplier, upgrade_data, upgrade)


func apply_operation(stat : Stat, upgrade_data : UpgradeData, upgrade):
	match upgrade_data.mode:
		UpgradeData.equasion_mode.ADD:
			stat.base_value += upgrade_data.stats[upgrade]
		UpgradeData.equasion_mode.MULTIPLY:
			stat.multiplier += upgrade_data.stats[upgrade]
