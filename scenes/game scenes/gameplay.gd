extends Scene

var round_time_remaining : float

@onready var round_duration_bar = %RoundDurationBar
@onready var player_paddle = %PlayerPaddle
@onready var enemy_spawner = %EnemySpawner
@onready var small_wisp_spawner = %SmallWispSpawner
@onready var small_wisp_group_spawner = %SmallWispGroupSpawner



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var round_duration = GlobalGameStats.round_duration.end_value
	round_duration_bar.max_value = round_duration
	round_duration_bar.value = round_duration
	round_duration_bar.size.x = GlobalGameStats.round_duration.end_value * round_duration_bar.x_size_multiplier
	round_time_remaining = round_duration
	
	if not GlobalGameStats.is_ability_unlocked(GlobalEnums.Abilities.UNLOCK_ENEMIES):
		enemy_spawner.set_process(false)
	
	if not GlobalGameStats.is_ability_unlocked(GlobalEnums.Abilities.UNLOCK_COLLECTIBLE_GROUPS):
		small_wisp_group_spawner.set_process(false)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	round_time_remaining -= delta
	round_duration_bar.value = round_time_remaining
	if round_time_remaining <= 0:
		GlobalSignals.transition_to_upgrade.emit()

func _on_ball_player_hit() -> void:
	round_time_remaining -= 1
