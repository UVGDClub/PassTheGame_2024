class_name CardInventory extends Control

const TOTAL_CARDS_STRING: String = "Deck Size: "
const TOTAL_CARDS_IN_DRAW_PILE_STRING: String = "Current Draw Pile Size: "
const SHUFFLE_TIMER_STRING: String = "Time until shuffle finished: "

@onready var card_grid = $Panel/ScrollContainer/GridContainer
@onready var total_cards_label = $Panel/HBoxContainer/cards_in_deck_lable
@onready var total_card_in_draw_pile_label = $Panel/HBoxContainer/cards_in_draw_pile
@onready var shuffle_timer_label = $Panel/HBoxContainer/shuffle_timer
@onready var display_card = load("res://src/cards/card_pack/card_display/card_display.tscn")

var inventory_open: bool = false

func _ready():
	visible = false

func _unhandled_input(event: InputEvent):
	if event.is_action_pressed("inventory"):
		if not inventory_open:
			open_inventory()
		else:
			close_inventory()
		get_viewport().set_input_as_handled()


func open_inventory() -> void:
	get_tree().paused = true
	inventory_open = true
	
	for i in card_grid.get_children():
		i.queue_free()
	
	for c in DeckManager.full_deck:
		var new_display_card = display_card.instantiate()
		card_grid.add_child(new_display_card)
		new_display_card.set_card(c)
	total_cards_label.text = TOTAL_CARDS_STRING + str(len(DeckManager.full_deck))
	total_card_in_draw_pile_label.text = TOTAL_CARDS_IN_DRAW_PILE_STRING + str(len(DeckManager.draw_pile))
	shuffle_timer_label.visible = DeckManager.is_currently_shuffling
	shuffle_timer_label.text = SHUFFLE_TIMER_STRING + str(ceil(DeckManager.timer.time_left)) + "s"
	
	visible = true
	

func close_inventory() -> void:
	get_tree().paused = false
	inventory_open = false
	visible = false


func _on_back_button_pressed():
	close_inventory()
