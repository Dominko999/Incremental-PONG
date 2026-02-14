extends RigidBody2D

@export var speed := 0.1
var vector := Vector2(0,0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	vector.x = -speed


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	constant_force = vector

func bounce_from_paddle():
	pass
