extends CharacterBody2D

@export var collision : CollisionShape2D
var height : float

func _ready() -> void:
	height = collision.shape.get_rect().size.y # gets Shape2D component of CollisionShape2D and from it gets y size of Rect2 component, 
												# whitch represents vertical height of the paddle collision. 
												# (Used to calculate ball bounce direction by ball.gd script)
