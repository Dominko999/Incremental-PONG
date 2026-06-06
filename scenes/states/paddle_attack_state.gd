extends State
class_name PaddleAttackState

@export var character : CharacterBody2D
@export var attack_speed : float = 300.0
@export var attack_distance : float = 25.0

var base_x_position : float
var max_x_position : float
var returning : bool

func enter() -> void:
	base_x_position = character.position.x
	max_x_position = character.position.x + attack_distance
	returning = false

func exit() -> void:
	character.velocity.x = 0
	character.position.x = base_x_position

func update(_delta: float) -> void:
	pass

func physics_update(delta: float) -> void:
	if not returning:
		character.velocity.x =  attack_speed * delta * 50
	elif returning:
		character.velocity.x = -attack_speed * delta * 50
	
	if character.position.x >= max_x_position:
		returning = true
	
	if returning and character.position.x <= base_x_position:
		transitioned.emit(self, "PaddleOnGroundState") 
	
	character.move_and_slide()
