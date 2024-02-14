class_name CardManager extends Node

signal card_drawn(card: Card)
signal deck_shuffled()

# Place all card resources in here
@export var all_cards_list: Array[Card]

@onready var timer = $timer
@onready var shuffle_sfx: AudioStream = load("res://assets/audio/sfx/shuffle_deck_temp.wav")

# How much time between each card draw
const DRAW_CARD_INTERVAL: float = 5.0
# How long shuffling takes
const SHUFFLE_TIME: float = 30.0 

var all_common_cards: Array[Card]
var all_uncommon_cards: Array[Card]
var all_rare_cards: Array[Card]
var all_legendary_cards: Array[Card]
var all_ethereal_cards: Array[Card]

# All the cards in the players deck
var full_deck: Array[Card] = [] 

# Cards yet to be drawn
var draw_pile: Array[Card] = [] 
# Cards that have been drawn
var discard_pile: Array[Card] = [] 

var is_currently_shuffling: bool = false
var card_cycle_started: bool = false
var _rng: RandomNumberGenerator = RandomNumberGenerator.new()

func _ready():
	_rng.randomize()
	create_card_lists()


func create_card_lists() -> void:
	for c in all_cards_list:
		match c.rarity:
			Card.CARD_RARITY.ETHEREAL:
				all_ethereal_cards.append(c)
			Card.CARD_RARITY.COMMON:
				all_common_cards.append(c)
			Card.CARD_RARITY.UNCOMMON:
				all_uncommon_cards.append(c)
			Card.CARD_RARITY.RARE:
				all_rare_cards.append(c)
			Card.CARD_RARITY.LEGENDARY:
				all_legendary_cards.append(c)
				


func start_card_draw_cycle() -> void:
	card_cycle_started = true
	discard_pile = []
	draw_pile = full_deck.duplicate()
	draw_pile.shuffle()
	timer.start(DRAW_CARD_INTERVAL)


func add_card(card: Card) -> void:
	if not card_cycle_started:
		start_card_draw_cycle()
	full_deck.append(card)
	draw_pile.append(card)


func remove_card(card: Card) -> void:
	full_deck.erase(card)
	if card in draw_pile:
		draw_pile.erase(card)
	

func shuffle_deck() -> void:
	discard_pile = []
	draw_pile = full_deck.duplicate()
	draw_pile.shuffle()
	emit_signal("deck_shuffled")
	timer.start(SHUFFLE_TIME)
	is_currently_shuffling = true
	await get_tree().create_timer(1).timeout
	SfxManager.play_sfx(shuffle_sfx, 0.1)


func draw_card() -> void:
	if len(draw_pile) <= 0:
		shuffle_deck()
		return
	var drawn_card: Card = draw_pile.pop_front()
	
	drawn_card.on_drawn()
	drawn_card.play()
	emit_signal("card_drawn", drawn_card)
	if drawn_card is EtherealCard:
		full_deck.erase(drawn_card)
	else:
		discard_pile.append(drawn_card)
	
	if len(draw_pile) <= 0:
		shuffle_deck()
	else:
		timer.start(DRAW_CARD_INTERVAL)


func _on_timer_timeout():
	if is_currently_shuffling:
		is_currently_shuffling = false
	draw_card()


func get_random_card() -> Card:
	var rarity_roll = _rng.randf()
	
	var current_sum: float = 0
	if rarity_roll <= Card.CARD_RARITY_VALUES[Card.CARD_RARITY.ETHEREAL]:
		return all_ethereal_cards[_rng.randi_range(0, len(all_ethereal_cards) - 1)]
	current_sum += Card.CARD_RARITY_VALUES[Card.CARD_RARITY.ETHEREAL]
	
	if rarity_roll <= current_sum + Card.CARD_RARITY_VALUES[Card.CARD_RARITY.COMMON]:
		return all_common_cards[_rng.randi_range(0, len(all_common_cards) - 1)]
	current_sum += Card.CARD_RARITY_VALUES[Card.CARD_RARITY.COMMON]
	
	if rarity_roll <= current_sum + Card.CARD_RARITY_VALUES[Card.CARD_RARITY.UNCOMMON]:
		return all_uncommon_cards[_rng.randi_range(0, len(all_uncommon_cards) - 1)]
	current_sum += Card.CARD_RARITY_VALUES[Card.CARD_RARITY.UNCOMMON]
	
	if rarity_roll <= current_sum + Card.CARD_RARITY_VALUES[Card.CARD_RARITY.RARE]:
		return all_rare_cards[_rng.randi_range(0, len(all_rare_cards) - 1)]
	current_sum += Card.CARD_RARITY_VALUES[Card.CARD_RARITY.RARE]
	
	return all_legendary_cards[_rng.randi_range(0, len(all_legendary_cards) - 1)]
