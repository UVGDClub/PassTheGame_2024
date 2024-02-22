class_name CardInventory extends Control

const TOTAL_CARDS_STRING: String = "Deck Size: "
const TOTAL_CARDS_IN_DRAW_PILE_STRING: String = "Current Draw Pile Size: "
const SHUFFLE_TIMER_STRING: String = "Time until shuffle finished: "

@onready var card_grid: GridContainer = $Panel/ScrollContainer/GridContainer
@onready var total_cards_label: Label = $Panel/HBoxContainer/cards_in_deck_lable
@onready var total_card_in_draw_pile_label: Label = $Panel/HBoxContainer/cards_in_draw_pile
@onready var shuffle_timer_label: Label = $Panel/HBoxContainer/shuffle_timer
@onready var display_card: PackedScene = load("res://src/cards/card_pack/card_display/card_display.tscn")

var inventory_open: bool = false

var selected_cards: Dictionary = {}

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
	selected_cards.clear()
	
	for i in card_grid.get_children():
		i.queue_free()
	
	for c in DeckManager.full_deck:
		var new_display_card = display_card.instantiate()
		card_grid.add_child(new_display_card)
		new_display_card.set_card(c)
		new_display_card.card_select_pressed.connect(_on_select_card_button_pressed)
	total_cards_label.text = TOTAL_CARDS_STRING + str(len(DeckManager.full_deck))
	total_card_in_draw_pile_label.text = TOTAL_CARDS_IN_DRAW_PILE_STRING + str(len(DeckManager.draw_pile))
	shuffle_timer_label.visible = DeckManager.is_currently_shuffling
	shuffle_timer_label.text = SHUFFLE_TIMER_STRING + str(ceil(DeckManager.timer.time_left)) + "s"
	
	visible = true
	

func close_inventory() -> void:
	get_tree().paused = false
	inventory_open = false
	visible = false
	selected_cards.clear()


func _on_back_button_pressed():
	close_inventory()


func _on_merge_button_pressed():
	if DeckManager.is_currently_shuffling && (selected_cards.size() >= 2):
		var merged_card: Card = DeckManager.all_other_cards[0]
		var effects: String   = "effect: "
		var description: String   = "Merged: "
		merged_card.merged_list = []
		for card: Card in selected_cards.values():
			description += card.card_name + " "
			effects += card.effect_text + " "
			merged_card.merged_list.append(card.effect_text)
#			print(card)
			DeckManager.remove_card(card)
		merged_card.effect_text = effects
		merged_card.card_description = description
		DeckManager.add_card(merged_card)

		for i in card_grid.get_children():
			i.queue_free()
		for c in DeckManager.full_deck:
			var new_display_card = display_card.instantiate()
			card_grid.add_child(new_display_card)
			new_display_card.set_card(c)
			new_display_card.card_select_pressed.connect(_on_select_card_button_pressed)

		selected_cards.clear()

func _on_select_card_button_pressed(card: Card):
	selected_cards[card.card_name] = card

	# optional size 3, doesnt have to be
	if selected_cards.size() > 3:
		selected_cards.erase(selected_cards.keys()[0])
	print("selected: ", selected_cards.keys())

#	attempting to add / remove select_border but this isnt the card_display object
#	card.get_node("select_border").visible = true
