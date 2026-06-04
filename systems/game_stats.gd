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
	GlobalSignals.upgrade_to_apply.connect(apply_upgrade)

func add_currency(currency : CurrencyData, amount : int):
	currency_data_dictionary[currency.type].amount_available += amount
	GlobalSignals.emit_signal("currency_changed", currency.type, amount)

func try_upgrade(upgrade_data : UpgradeData):
	for currency in upgrade_data.price:
		var cost = upgrade_data.price[currency]
		if currency_data_dictionary[currency].amount_available < cost:
			return
	apply_upgrade(upgrade_data)

func get_stat_end_value(stat : GlobalEnums.Stats):
	match stat:
		GlobalEnums.Stats.ROUND_DURATION: return round_duration.end_value
		GlobalEnums.Stats.BALL_DAMAGE: return ball_damage.end_value
		GlobalEnums.Stats.PADDLE_SPEED: return paddle_speed.end_value
		GlobalEnums.Stats.ENEMIES_SPAWN_RATE: return enemies_spawn_rate.end_value
		GlobalEnums.Stats.MONEY_MULTIPLIER: return money_multiplier.end_value

func get_stat(stat : GlobalEnums.Stats):
	match stat:
		GlobalEnums.Stats.ROUND_DURATION: return round_duration
		GlobalEnums.Stats.BALL_DAMAGE: return ball_damage
		GlobalEnums.Stats.PADDLE_SPEED: return paddle_speed
		GlobalEnums.Stats.ENEMIES_SPAWN_RATE: return enemies_spawn_rate
		GlobalEnums.Stats.MONEY_MULTIPLIER: return money_multiplier
		

func apply_upgrade(upgrade_data : UpgradeData): ## Increases stats specified and subtracts currency
	for currency in upgrade_data.price:
		var cost = upgrade_data.price[currency]
		currency_data_dictionary[currency].amount_available -= cost
	for upgrade in upgrade_data.stats:
		match upgrade:
			GlobalEnums.Stats.ROUND_DURATION:
				apply_operation(round_duration, upgrade_data, upgrade)
			GlobalEnums.Stats.BALL_DAMAGE:
				apply_operation(ball_damage, upgrade_data, upgrade)
			GlobalEnums.Stats.PADDLE_SPEED:
				apply_operation(paddle_speed, upgrade_data, upgrade)
			GlobalEnums.Stats.ENEMIES_SPAWN_RATE:
				apply_operation(enemies_spawn_rate, upgrade_data, upgrade)
			GlobalEnums.Stats.MONEY_MULTIPLIER:
				apply_operation(money_multiplier, upgrade_data, upgrade)


func apply_operation(stat : Stat, upgrade_data : UpgradeData, upgrade):
	match upgrade_data.mode:
		UpgradeData.equasion_mode.ADD:
			stat.base_value += upgrade_data.stats[upgrade]
		UpgradeData.equasion_mode.MULTIPLY:
			stat.multiplier += upgrade_data.stats[upgrade]
