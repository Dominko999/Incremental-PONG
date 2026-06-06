extends Resource

class_name UpgradeData

enum equasion_mode {
	ADD,
	MULTIPLY
}


@export var stats : Dictionary[GlobalEnums.Stats, float]
@export var mode : equasion_mode
@export var price : Dictionary[GlobalEnums.CurrencyType, int]
@export var ability_to_unlock : GlobalEnums.Abilities = -1
