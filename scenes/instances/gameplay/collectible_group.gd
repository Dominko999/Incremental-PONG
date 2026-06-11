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

## particles that flow between collectibles
@export var trail_particles : GPUParticles2D 

## amount of particles per link between two collectibles
@export var particles_per_link : int = 5

var amount : int
var amount_collected : int

var all_collectibles : Array[Collectible] = []
var recorded_positions : PackedVector2Array = []
var active_start_index : int = 0
var total_dead : int = 0

var previous_y_position : float


func _ready() -> void:
	@warning_ignore("narrowing_conversion")
	amount = randi_range(amount_range.x,amount_range.y)
	
	for i in range(0, amount):
		var instance = collectible.instantiate() as Collectible
		add_child(instance)
		
		instance.global_position.y = calculate_collectible_y_position(instance.global_position.y)
		instance.global_position.x += distance_horizontal * i
		
		
		all_collectibles.append(instance)
		recorded_positions.append(instance.position)
		
		instance.collected_by_player.connect(func(): amount_collected += 1)
	
	if modulate_color:
		tint_color()
		
	update_shader_parameters()


func tint_color():
	var rand_color = Color.DODGER_BLUE
	for child in all_collectibles:
		if is_instance_valid(child):
			child.modulate = rand_color


func calculate_collectible_y_position(y_global_position : float) -> float:
	if previous_y_position == null:
		previous_y_position = y_global_position
	
	var next_global_y = clampf(previous_y_position + distance_vertical * randi_range(-1, 1), -500, 500)

	previous_y_position = next_global_y

	return next_global_y
	

func _process(_delta: float) -> void:
	for i in range(all_collectibles.size()):
		var c = all_collectibles[i]
		if is_instance_valid(c) and not c.is_queued_for_deletion():
			recorded_positions[i] = c.position
			
	update_shader_parameters()


func update_shader_parameters() -> void:
	if trail_particles == null:
		return
		
	var mat = trail_particles.process_material as ShaderMaterial
	if mat:
		if total_dead >= amount:
			trail_particles.emitting = false
		else:
			mat.set_shader_parameter("points", recorded_positions)
			mat.set_shader_parameter("point_count", recorded_positions.size())
			mat.set_shader_parameter("active_start_index", active_start_index)


func _on_child_exiting_tree(node : Node) -> void:
	if node is Collectible:
		total_dead += 1
		
		var new_start = amount
		for i in range(amount):
			var c = all_collectibles[i]
			if is_instance_valid(c) and not c.is_queued_for_deletion() and c != node:
				new_start = i
				break
		active_start_index = new_start
		
		if total_dead >= amount:
			if amount_collected == amount:
				GlobalSoundManager.play_sfx(GlobalEnums.Sounds.ALL_COLLECTED, true)
				give_reward()
			queue_free()


func give_reward() -> void:
	if currency_reward != null:
		GlobalGameStats.add_currency(currency_reward.currency, currency_reward.amount * amount)
