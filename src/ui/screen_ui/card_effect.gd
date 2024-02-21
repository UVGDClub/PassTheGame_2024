extends Control

@onready var common_bg = load("res://assets/art/ui/UI backgrounds/common_bg.png")
@onready var uncommon_bg = load("res://assets/art/ui/UI backgrounds/uncommon_bg.png")
@onready var rare_bg = load("res://assets/art/ui/UI backgrounds/rare_bg.png")
@onready var legendary_bg = load("res://assets/art/ui/UI backgrounds/legendary_bg.png")
@onready var ethereal_bg = load("res://assets/art/ui/UI backgrounds/ethereal_bg.png")
@onready var effect_bg = $Rarity_Bg
@onready var title = $Card_Name
@onready var duration = $Effect_Duration
@onready var effect = $Effect_Description
# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if DeckManager.is_currently_shuffling:
		title.text = ""
		effect.text = "Shuffling"
	else:
		if DeckManager.drawn_card != null:
			title.text = DeckManager.drawn_card.card_name
			effect.text = DeckManager.drawn_card.effect_text
			match DeckManager.drawn_card.rarity:
				Card.CARD_RARITY.ETHEREAL:
					effect_bg.texture = ethereal_bg
					title.add_theme_color_override("font_color",Color("00e7ff"))
					duration.add_theme_color_override("font_color",Color("004175"))
					effect.add_theme_color_override("font_color",Color("004175"))
				Card.CARD_RARITY.COMMON:
					effect_bg.texture = common_bg
					title.add_theme_color_override("font_color",Color("c7c7c7"))
					duration.add_theme_color_override("font_color",Color("272727"))
					effect.add_theme_color_override("font_color",Color("272727"))
				Card.CARD_RARITY.UNCOMMON:
					effect_bg.texture = uncommon_bg
					title.add_theme_color_override("font_color",Color("ff5700"))
					duration.add_theme_color_override("font_color",Color("640505"))
					effect.add_theme_color_override("font_color",Color("640505"))
				Card.CARD_RARITY.RARE:
					effect_bg.texture = rare_bg
					title.add_theme_color_override("font_color",Color("7500ff"))
					duration.add_theme_color_override("font_color",Color("400040"))
					effect.add_theme_color_override("font_color",Color("400040"))
				Card.CARD_RARITY.LEGENDARY:
					effect_bg.texture = legendary_bg
					title.add_theme_color_override("font_color",Color("ff0058"))
					duration.add_theme_color_override("font_color",Color("750027"))
					effect.add_theme_color_override("font_color",Color("750027"))
		else:
			title.text = ""
			effect.text = "Deck Empty"
				
	duration.text = str(round(DeckManager.timer.get_time_left() * 10) / 10)


