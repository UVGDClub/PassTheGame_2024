class_name CardPackPickup extends Node2D

@onready var card_picker_ui = load("res://src/cards/card_pack/card_picker_ui.tscn")

func open_pack() -> void:
	var ui = DeckManager.get_tree().get_nodes_in_group("UI")[0]
	var new_picker = card_picker_ui.instantiate()
	DeckManager.cards_collected += 1
	ui.add_child(new_picker)
	queue_free()


func _on_area_2d_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	open_pack()
