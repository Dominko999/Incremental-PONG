extends Node2D
class_name CollectibleGroup


@export var collectible : PackedScene

## Amount of collectibles in group
@export var amount_range := Vector2(1,1)

## Horizontal distance between subsequent collectibles
@export var distance_horizontal : float

## Vertical distance between subsequent collectibles
@export var distance_vertical : float

## Reward for collecting all collectibles
@export var currency_reward : CurrencyReward

## If True currency collor will be randomly tinted
@export var modulate_color : bool = false

var amount : int
var amount_collected : int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	@warning_ignore("narrowing_conversion")
	amount = randi_range(amount_range.x,amount_range.y)
	
	var current_y = 0
	for i in range(0,amount):
		var instance = collectible.instantiate()
		instance.global_position.x += i * distance_horizontal
		instance.global_position.y = current_y
		current_y += distance_vertical * randi_range(-1,1)
		add_child(instance)
		instance.collected_by_player.connect(func(): amount_collected += 1)
	
	if modulate_color:
		tint_color()


func tint_color():
	var rand_color = Color(
	randf_range(0.1,0.3), 
	randf_range(0.7,1.0), 
	1.0, 
	1.0)
	for child in get_children():
		child.modulate = rand_color


func _on_child_exiting_tree(_node : Node) -> void:
	print(amount_collected)
	if get_child_count() == 1:
		if amount_collected == amount:
			print("NAGRODA")
			give_reward()
		queue_free()


func give_reward() -> void:
	if currency_reward != null:
		GlobalGameStats.add_currency(currency_reward.currency, currency_reward.amount * amount)
