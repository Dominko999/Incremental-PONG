extends Node
class_name Stat

var base_value : float
var multiplier : float = 1

func _init(_base_value : float = 0.0) -> void:
	base_value = _base_value

var end_value : float:
	get:
		return base_value * multiplier
