class_name CardManager extends Node

signal card_drawn(card: Card)
signal deck_shuffled()

@onready var timer = $timer
@onready var shuffle_sfx: AudioStream = load("res://assets/audio/sfx/shuffle_deck_temp.wav")

# How much time between each card draw
const DRAW_CARD_INTERVAL: float = 5.0
# How long shuffling takes
const SHUFFLE_TIME: float = 30.0 

# All the cards in the players deck
var full_deck: Array[Card] = [] 

# Cards yet to be drawn
var draw_pile: Array[Card] = [] 
# Cards that have been drawn
var discard_pile: Array[Card] = [] 


func _ready():
	start_card_draw_cycle()


func start_card_draw_cycle() -> void:
	discard_pile = []
	draw_pile = full_deck.duplicate()
	draw_pile.shuffle()
	timer.start(DRAW_CARD_INTERVAL)


func add_card(card: Card) -> void:
	full_deck.append(card)
	draw_pile.append(card)


func remove_card(card: Card) -> void:
	full_deck.erase(card)
	if card in draw_pile:
		draw_pile.erase(card)
	

func shuffle_deck() -> void:
	print("shuffle")
	discard_pile = []
	draw_pile = full_deck.duplicate()
	draw_pile.shuffle()
	emit_signal("deck_shuffled")
	timer.start(SHUFFLE_TIME)
	await get_tree().create_timer(1).timeout
	SfxManager.play_sfx(shuffle_sfx, 0.05)


func draw_card() -> void:
	print("draw")
	if len(draw_pile) <= 0:
		shuffle_deck()
		return
	var drawn_card: Card = draw_pile.pop_front()
	
	drawn_card.on_drawn()
	drawn_card.play()
	emit_signal("card_drawn", drawn_card)
	discard_pile.append(drawn_card)
	
	if len(draw_pile) <= 0:
		shuffle_deck()
	else:
		timer.start(DRAW_CARD_INTERVAL)
		


func _on_timer_timeout():
	draw_card()
