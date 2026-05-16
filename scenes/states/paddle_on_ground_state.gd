extends State
class_name PaddleOnGroundState

@export var character : CharacterBody2D
var speed : float = GlobalGameStats.paddle_speed.end_value

func enter() -> void:
	pass

func exit() -> void:
	pass

func update(_delta: float) -> void:
	pass

func physics_update(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		transitioned.emit(self, "PaddleAttackState")
	
	
	var direction := Input.get_axis("ui_up", "ui_down")
	if direction:
		character.velocity.y = direction * speed
	else:
		character.velocity.y = move_toward(character.velocity.y, 0, speed/10)

	character.move_and_slide()
