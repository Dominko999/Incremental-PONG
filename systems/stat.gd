extends Node
class_name Stat

var original_value : float
var original_multiplier : float = 1

var base_value : float
var multiplier : float = 1

var end_value : float:
	get:
		return base_value * multiplier


func _init(_base_value : float = 0.0) -> void:
	base_value = _base_value
	original_value = _base_value


func reset() -> void:
	base_value = original_value
	multiplier = original_multiplier