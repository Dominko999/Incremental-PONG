extends Node

@onready var click_sound = preload("res://music/SFX_UI_Click_Organic_Pop_Liquid_Thick_Generic_1.wav")
var player : AudioStreamPlayer

func _ready():
	player = AudioStreamPlayer.new()
	add_child(player)
	player.stream = click_sound
	
	get_tree().node_added.connect(_on_node_added)

func _on_node_added(node):
	if node is BaseButton:
		if not node.pressed.is_connected(_play_click_sound):
			node.pressed.connect(_play_click_sound)
			

func _play_click_sound():
	if player.playing:
		return
	
	player.play()
