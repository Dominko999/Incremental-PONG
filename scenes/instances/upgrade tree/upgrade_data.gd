extends Resource

class_name UpgradeData

enum stats_list {
	ROUND_DURATION,
	BALL_DAMAGE,
	PADDLE_SPEED,
	ENEMIES_SPAWN_RATE,
	MONEY_MULTIPLIER
}

enum equasion_mode {
	ADD,
	MULTIPLY
}


@export var stats : Dictionary[stats_list, float]
@export var mode : equasion_mode
@export var price : Dictionary[GlobalEnums.CurrencyType, int]
