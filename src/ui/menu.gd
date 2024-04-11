extends Node

var level = "res://src/proc_gen/GeneratingLevel.tscn"

func _ready():
	pass

func _on_button_pressed():
	get_tree().change_scene_to_file(level)
