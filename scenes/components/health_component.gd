extends Node
class_name HealthComponent

signal on_death()

@export var max_health : int
@export var health : int = max_health:
	set(new_health):
		health = new_health
		health = clamp(health, 0, max_health)

@export var death_reward : CurrencyReward


func take_damage(amount):
	health -= amount
	if health <= 0:
		die()

func die():
	if death_reward != null:
		GlobalGameStats.add_currency(death_reward.currency, death_reward.amount)
	
	on_death.emit()
	get_parent().queue_free()
