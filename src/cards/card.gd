class_name Card extends Resource

enum CARD_RARITY {
	COMMON,
	UNCOMMON,
	RARE,
	LEGENDARY,
	ETHEREAL,
}

const CARD_RARITY_VALUES: Dictionary = {
	CARD_RARITY.COMMON: 0.4,
	CARD_RARITY.UNCOMMON: 0.3,
	CARD_RARITY.RARE: 0.1,
	CARD_RARITY.LEGENDARY: 0.05,
	CARD_RARITY.ETHEREAL: 0.15,
}

const CARD_RARITY_BACKGROUND_TEXTURES: Dictionary = {
	CARD_RARITY.COMMON: preload("res://assets/art/cards/card_backgrounds/common_card_background_temp.png"),
	CARD_RARITY.UNCOMMON: preload("res://assets/art/cards/card_backgrounds/uncommon_card_background_temp.png"),
	CARD_RARITY.RARE: preload("res://assets/art/cards/card_backgrounds/rare_card_background_temp.png"),
	CARD_RARITY.LEGENDARY: preload("res://assets/art/cards/card_backgrounds/legendary_card_background_temp.png"),
	CARD_RARITY.ETHEREAL: preload("res://assets/art/cards/card_backgrounds/ethereal_card_background_temp.png"),
}

@export var card_name: String = ""
@export_multiline var card_description: String = ""
@export var rarity: CARD_RARITY
@export var picture: Texture
@export var on_card_played_sfx: AudioStream = null
@export var duration: float
var player: Player

func on_drawn() -> void:
	if on_card_played_sfx != null:
		SfxManager.play_sfx(on_card_played_sfx)

func play() -> void:
	assert(false, "Each card must implement their own play() function.")

