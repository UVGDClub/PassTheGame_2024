class_name Card extends Node2D

@export var card_name: String = ""
@export_multiline var card_description: String = ""
@export var on_card_played_sfx: AudioStream = null

@onready var player: Player = get_tree().get_nodes_in_group("Player")[0]


func on_drawn() -> void:
	if on_card_played_sfx != null:
		SfxManager.play_sfx(on_card_played_sfx)

func play() -> void:
	pass

