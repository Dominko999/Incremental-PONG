extends Node

const SAVE_GAME_PATH := "user://save.tres"

var save_file : SaveFile:
	set(value):
		save_file = value
		if save_file and not save_file.save_file_changed.is_connected(write_save):
			save_file.save_file_changed.connect(write_save) 

func _ready() -> void:
	GlobalSignals.transition_to_gameplay.connect(write_save)
	GlobalSignals.transition_to_upgrade.connect(write_save)
	GlobalSignals.transition_to_menu.connect(write_save)

func write_save() -> void:
	if save_file: 
		ResourceSaver.save(save_file, SAVE_GAME_PATH)
	else:
		push_error("Cannot write save: save_file is null")
	
		

func save_exists() -> bool:
	return FileAccess.file_exists(SAVE_GAME_PATH)

func load_save() -> void:
	if save_exists():
		var loaded_res = ResourceLoader.load(SAVE_GAME_PATH)
		if loaded_res is SaveFile:
			save_file = loaded_res
		else:
			push_error("Loaded resource is not a SaveFile. Creating new one.")
			create_new_save()
	else:
		push_error("Attempted to load save, but file does not exist.")

func create_new_save() -> void:
	if save_exists():
		DirAccess.remove_absolute(SAVE_GAME_PATH)

	save_file = SaveFile.new()
	write_save()
	
