extends Collectible

@export var speed : float = 200

@onready var sprite :AnimatedSprite2D = %AnimatedSprite2D


func _process(delta: float) -> void:
	position.x -= speed * delta
