extends Node


var sounds = {
	GlobalEnums.Sounds.CLICK : preload("res://music/SFX_UI_Click_Organic_Pop_Liquid_Thick_Generic_1.wav"),
	GlobalEnums.Sounds.EXPLOSION : preload("res://music/explosion.wav"),
	GlobalEnums.Sounds.PICKUP : preload("res://music/pickup.wav"),
	GlobalEnums.Sounds.BOUNCE : preload("res://music/bounce.wav")
}

var music = preload("res://music/main_track_v1.wav")

func _ready():
	get_tree().node_added.connect(_on_node_added)
	var music_player = AudioStreamPlayer.new()
	music_player.stream = music
	add_child(music_player)
	music_player.play()

func _on_node_added(node):
	if node is BaseButton:
		if not node.pressed.is_connected(_play_click_sound):
			node.pressed.connect(_play_click_sound)


func _play_click_sound():
	play_sfx(GlobalEnums.Sounds.CLICK)


func play_sfx(sound : GlobalEnums.Sounds, randomize_pitch : bool = false):
	if not sounds.has(sound):
		push_warning("AudioManager: No sound")
		return
	
	var player = AudioStreamPlayer.new()
	
	var sound_to_play = sounds[sound]
	
	if randomize_pitch:
		player.pitch_scale = randf_range(1, 1.2)
	
	player.stream = sound_to_play
	
	add_child(player)
	player.play()
	
	player.finished.connect(player.queue_free)
