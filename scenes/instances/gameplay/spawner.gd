extends Area2D
class_name Spawner

@export var scene_to_spawn : PackedScene
@export var spawn_rate_modifier_name : String
@export var parent_node_name : String

var spawn_timer : float = 0.0
@export var treshold_range : Vector2 = Vector2(4.0,5.0)
@export var randomization_value : float = 1

## If true instace will be spawned inside Collision2D object, whitch must be created as a child of this object
@export var spawn_in_child_collision_shape : bool
@export var spawn_area_shape : CollisionShape2D 

var parent_node : Node2D
var spawn_rate_modifier : float
var shape : Shape2D
var treshold : float


func _ready() -> void:
	parent_node = get_tree().get_first_node_in_group(parent_node_name)
	
	spawn_rate_modifier = GlobalGameStats.enemies_spawn_rate.end_value
	
	if spawn_in_child_collision_shape:
		shape = spawn_area_shape.shape
	
	randomize_treshold()
	
func _process(delta: float) -> void:
	
	spawn_timer += delta * spawn_rate_modifier
	if spawn_timer >= treshold:
		randomize_treshold()
		spawn_timer = 0
		spawn_enemy()

func randomize_treshold():
	treshold = randf_range(treshold_range.x,treshold_range.y)

func spawn_enemy():
	var instance = scene_to_spawn.instantiate()
	parent_node.add_child(instance)
	if spawn_in_child_collision_shape:
		instance.global_position = get_random_place_in_child_area()

func get_random_place_in_child_area(): 
	var extents = shape.extents 
	var x = randi_range(-extents.x, extents.x)
	var y = randi_range(-extents.y,extents.y)

	return spawn_area_shape.to_global(Vector2(x,y))
