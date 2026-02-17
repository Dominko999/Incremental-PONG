extends Node
class_name HealthComponent

@export var max_health : int
@export var health : int = max_health:
	set(new_health):
		health = new_health
		health = clamp(health, 0, max_health)



func take_damage(amount):
	health -= amount
	if health <= 0:
		die()

func die():
	get_parent().queue_free()
