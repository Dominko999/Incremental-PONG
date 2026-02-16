extends Area2D
class_name HurtboxComponent

@export var health_component : HealthComponent

func damage(amount):
	health_component.take_damage(amount)
