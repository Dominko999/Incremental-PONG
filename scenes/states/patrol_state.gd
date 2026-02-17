extends State
class_name PatrolState
@export var enemy : CharacterBody2D
@export var shooter : ShooterComponent
@export var frequency : float = 0.3
@export var distance : int = 50
@export var attack_cooldown : float = 5.0
var base_position : Vector2
var movement_time : float = 0.0
var time_after_last_attack : float = 0.0


func enter() -> void:
	base_position = enemy.position

func physics_update(delta: float) -> void:
	pass
	movement_time += delta
	time_after_last_attack += delta
	
	enemy.position.y = base_position.y + distance * sin(2 * PI * frequency * movement_time)
	
	if time_after_last_attack >= attack_cooldown:
		shooter.shoot()
		time_after_last_attack = 0
