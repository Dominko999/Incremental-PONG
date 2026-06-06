extends Node
class_name GameStats

var round_duration : Stat = Stat.new(20.0)
var ball_damage : Stat = Stat.new(1.0)
var paddle_speed : Stat = Stat.new(500.0)
var enemies_spawn_rate : Stat = Stat.new(1.0)
var money_multiplier : Stat = Stat.new(1.0)

@onready var stats_map : Dictionary = {
	GlobalEnums.Stats.ROUND_DURATION: round_duration,
	GlobalEnums.Stats.BALL_DAMAGE: ball_damage,
	GlobalEnums.Stats.PADDLE_SPEED: paddle_speed,
	GlobalEnums.Stats.ENEMIES_SPAWN_RATE: enemies_spawn_rate,
	GlobalEnums.Stats.MONEY_MULTIPLIER: money_multiplier
}

var currency_data_dictionary : Dictionary:  # przechowywuje dane wszystkich walut, jakie ma gracz
	set(value):
		currency_data_dictionary = value
		save_currency()
@onready var blue_currency : CurrencyData = preload("res://currency/blue_currency_data.tres")
@onready var red_currency : CurrencyData = preload("res://currency/red_currency_data.tres")

# Store unlocked abilities: {GlobalEnums.Abilities.DASH : True}
var unlocked_abilities : Dictionary = {}


func _ready() -> void:
	currency_data_dictionary[blue_currency.type] = blue_currency
	currency_data_dictionary[red_currency.type] = red_currency
	GlobalSignals.upgrade_to_apply.connect(apply_upgrade)


func save_stats() -> void:
	if not GlobalSaveManager.save_file:
		return

	var save_data = {}

	for stat_type in stats_map:
		var stat_obj = stats_map[stat_type]
		save_data[stat_type] = {
			"base" : stat_obj.base_value,
			"mult" : stat_obj.multiplier
		}

		GlobalSaveManager.save_file.stats_data = save_data


func load_stats() -> void:
	if not GlobalSaveManager.save_file:
		return
	
	var save_data = GlobalSaveManager.save_file.stats_data
	for stat_type in save_data:
		var data = save_data[stat_type]
		var stat_obj = stats_map[stat_type]
		stat_obj.base_value = data.get("base", stat_obj.base_value)
		stat_obj.multiplier = data.get("mult", stat_obj.multiplier)


func purge_stats() -> void:
	for stat_type in stats_map:
		stats_map[stat_type].reset()
	save_stats()


func save_currency() -> void:
	if not GlobalSaveManager.save_file:
		return
	var save_data = GlobalSaveManager.save_file.currency_data
	for type in currency_data_dictionary:
		if not save_data.has(type):
			save_data[type] = {
				"amount_available": 0,
				"total_amount_collected": 0
			}
		save_data[type].amount_available = currency_data_dictionary[type].amount_available
		save_data[type].total_amount_collected = currency_data_dictionary[type].total_amount_collected


func load_currency() -> void:
	if not GlobalSaveManager.save_file:
		return
	var save_data = GlobalSaveManager.save_file.currency_data
	for type in save_data:
		if currency_data_dictionary.has(type):
			currency_data_dictionary[type].amount_available = save_data[type].amount_available
			currency_data_dictionary[type].total_amount_collected = save_data[type].total_amount_collected


func purge_currency() -> void:
	for type in currency_data_dictionary:
		if currency_data_dictionary.has(type):
			currency_data_dictionary[type].amount_available = 0
			currency_data_dictionary[type].total_amount_collected = 0
	save_currency()


func add_currency(currency : CurrencyData, amount : int):
	var currency_to_add = round(amount * money_multiplier.end_value)
	currency_data_dictionary[currency.type].amount_available += currency_to_add
	GlobalSignals.emit_signal("currency_changed", currency.type, currency_to_add)
	save_currency()


func save_abilities() -> void:
	if not GlobalSaveManager.save_file:
		return
	GlobalSaveManager.save_file.unlocked_abilities = unlocked_abilities.duplicate()


func load_abilities() -> void:
	if not GlobalSaveManager.save_file:
		return
	unlocked_abilities = GlobalSaveManager.save_file.unlocked_abilities.duplicate()


func purge_abilities() -> void:
	unlocked_abilities = {}
	save_abilities()


func unlock_ability(ability: GlobalEnums.Abilities) -> void:
	unlocked_abilities[ability] = true
	save_abilities()


func is_ability_unlocked(ability: GlobalEnums.Abilities) -> bool:
	return unlocked_abilities.get(ability, false)


func try_upgrade(upgrade_data : UpgradeData):
	for currency in upgrade_data.price:
		var cost = upgrade_data.price[currency]
		if currency_data_dictionary[currency].amount_available < cost:
			return
	apply_upgrade(upgrade_data)


func get_stat_end_value(stat : GlobalEnums.Stats):
	return get_stat(stat).end_value


func get_stat(stat : GlobalEnums.Stats):
	return stats_map.get(stat)


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
	if upgrade_data.ability_to_unlock != -1:
		unlock_ability(upgrade_data.ability_to_unlock)
	save_currency()
	save_stats()


func apply_operation(stat : Stat, upgrade_data : UpgradeData, upgrade):
	match upgrade_data.mode:
		UpgradeData.equasion_mode.ADD:
			stat.base_value += upgrade_data.stats[upgrade]
		UpgradeData.equasion_mode.MULTIPLY:
			stat.multiplier += upgrade_data.stats[upgrade]
