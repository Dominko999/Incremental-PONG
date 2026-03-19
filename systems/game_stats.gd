extends Node
class_name GameStats

var round_duration : float = 20.0
var ball_damage : int = 1
var paddle_speed : float = 300
var enemies_spawn_rate : float = 1
var money_multiplier : float = 1

var currencies : Dictionary # przechowywuje ilość wszystkich walut, jakie ma gracz



func add_currency(currency : Currency, amount):
	var id = currency.id
	currencies[id] = currencies.get(id, 0) + amount
	print(currencies[id])
