extends CharacterBody2D

@export var frequency := 0.3
@export var distance := 50
var base_position : Vector2
var time := 0.0
signal take_damage

func _ready():
	base_position = position
	print(base_position.y)

func _physics_process(delta: float) -> void:
	time += delta
	
	position.y = base_position.y + distance * sin(2 * PI * frequency * time)
