extends Node
class_name EnemySpawner

@export var enemy_scene : PackedScene
var enemy_spawn_rate : float = GlobalGameStats.enemies_spawn_rate
@export var enemies_parent_group : String = 'enemies_parent'

var spawn_timer : float = 0.0
@export var treshold : float = 5

var enemy_node : Node2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	enemy_node = get_tree().get_first_node_in_group(enemies_parent_group)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	spawn_timer += delta
	if spawn_timer >= treshold:
		spawn_timer = 0
		spawn_enemy()

func spawn_enemy():
	var enemy = enemy_scene.instantiate()
	
	enemy_node.add_child(enemy)
