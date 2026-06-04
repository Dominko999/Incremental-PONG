extends VBoxContainer

class_name StatChangeContainer


var upgrade_data: UpgradeData:
	set(value):
		upgrade_data = value
		_update_display()		

# Called when the node enters the scene tree for the first time.
func _init(data: UpgradeData) -> void:
	upgrade_data = data
	fill_up_stats()

func _update_display():
	for child in get_children():
		child.queue_free()
	fill_up_stats()

func fill_up_stats():
	var stats = upgrade_data.stats
	var mode = upgrade_data.mode
	for stat in stats:
		var amount_to_chamge = stats[stat]
		add_stat_row(stat, amount_to_chamge, mode)
	

func add_stat_row(stat, amount_to_change, mode):
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	alignment = BoxContainer.ALIGNMENT_CENTER
	var label: Label = Label.new()
	
	add_theme_constant_override("separation", 10)
	
	var current_stat = GlobalGameStats.get_stat(stat)
	
	if mode == UpgradeData.equasion_mode.ADD:
		var base_value = current_stat.base_value + amount_to_change
		var multiplier = current_stat.multiplier
		var new_end_value = base_value * multiplier
		
		label.text = str(current_stat.end_value) + " -> " + str(new_end_value)
		
	if mode == UpgradeData.equasion_mode.MULTIPLY:
		var base_value = current_stat.base_value
		var multiplier = current_stat.multiplier + amount_to_change
		var new_end_value = roundf(base_value * multiplier)
		
		label.text = str(roundf(current_stat.end_value)) + " -> " + str(new_end_value)
	
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(label)
