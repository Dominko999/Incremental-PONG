extends State
class_name SpawnedState

@export var enemy : CharacterBody2D
@export var speed : int = 100

var go_to_location : Vector2

func enter() -> void:
	go_to_location = Vector2(randf_range(-300,600),randf_range(-300,300))

func physics_update(delta: float) -> void:
	var direction = enemy.position.direction_to(go_to_location)
	enemy.move_and_collide(direction * speed * delta)
	
	if enemy.position.x <= go_to_location.x:
		transitioned.emit(self, 'PatrolState')
