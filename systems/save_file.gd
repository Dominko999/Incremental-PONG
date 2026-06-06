extends Resource
class_name SaveFile

signal save_file_changed

# Store stat values in a dictionary: { "stat_name": {"base": 1.0, "mult": 1.0} }
@export var stats_data : Dictionary = {}:
	set(value):
		stats_data = value
		save_file_changed.emit()
# Store currency amounts: { "currency_type": amount }
@export var currency_data : Dictionary = {}:
	set(value):
		currency_data = value
		save_file_changed.emit()
# Store upgrade tree levels: { "upgrade_id": level }
@export var upgrade_levels : Dictionary = {}:
	set(value):
		upgrade_levels = value
		save_file_changed.emit()
# Store unlocked abilities: {GlobalEnums.Abilities.DASH : True}
@export var unlocked_abilities : Dictionary = {}:
	set(value):
		unlocked_abilities = value
		save_file_changed.emit()
