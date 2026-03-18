extends Collectible

@export var speed : float = 300

func _process(delta: float) -> void:
	position.x -= speed * delta
