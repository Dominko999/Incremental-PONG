extends Node2D

@export var death_sfx : GlobalEnums.Sounds = -1





func _on_health_component_on_death() -> void:
	if death_sfx != -1:
		GlobalSoundManager.play_sfx(death_sfx)
