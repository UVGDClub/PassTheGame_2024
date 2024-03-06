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

var selected_cards: Array = []

func _ready():
	visible = false
	$Panel/tooltip.text = ""
	$Panel/ScrollContainer/GridContainer.child_entered_tree.connect(on_GridContainer_child_entered_tree)

func on_GridContainer_child_entered_tree(child: CardDisplayUI):
	child.card_add_button_pressed.connect(_on_card_add_button_pressed)

func _on_card_add_button_pressed(card: Card):
	$Panel/tooltip.text = card.card_name + "\n\n" + card.card_description

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
		new_display_card.card_select_toggled.connect(_on_select_card_button_toggled)
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
		for card: Card in selected_cards:
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
			new_display_card.card_select_toggled.connect(_on_select_card_button_toggled)

		selected_cards.clear()

func _on_select_card_button_toggled(card: Card, toggled_on: bool):
	if toggled_on:
		selected_cards.push_back(card)
	else:
		selected_cards.erase(card)
