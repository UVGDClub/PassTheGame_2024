extends Control

const NUM_CARDS_TO_OFFER: int = 3

@onready var card_display_hbox = $Panel/HBoxContainer
@onready var card_display = load("res://src/cards/card_pack/card_display/card_display.tscn")

func _ready():
	get_tree().paused = true
	for i in range(NUM_CARDS_TO_OFFER):
		var new_card_display = card_display.instantiate()
		card_display_hbox.add_child(new_card_display)
		new_card_display.set_card(DeckManager.get_random_card())
		new_card_display.card_add_button_pressed.connect(_on_add_card_button_pressed)


func close_card_picker() -> void:
	get_tree().paused = false
	queue_free()


func _on_add_card_button_pressed(card_to_add: Card):
	DeckManager.add_card(card_to_add)
	close_card_picker()
