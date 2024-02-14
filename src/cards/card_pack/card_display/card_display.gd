class_name CardDisplayUI extends Control

signal card_add_button_pressed(card: Card)

@export var display_card: Card = null

@onready var background_sprite = $background_sprite
@onready var card_image_sprite = $background_sprite/card_image
@onready var name_label = $background_sprite/name_label
@onready var description_label = $background_sprite/description_label
@onready var add_card_button = $background_sprite/add_card_button


func _ready():
	if display_card != null:
		set_card(display_card)


func set_card(new_card: Card) -> void:
	display_card = new_card
	background_sprite.texture = display_card.CARD_RARITY_BACKGROUND_TEXTURES[display_card.rarity]
	card_image_sprite.texture = display_card.picture
	name_label.text = display_card.card_name
	description_label.text = display_card.card_description



func _on_add_card_button_pressed():
	emit_signal("card_add_button_pressed", display_card)
