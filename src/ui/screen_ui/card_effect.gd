extends Control

@onready var common_bg = load("res://assets/art/ui/UI backgrounds/common_bg.png")
@onready var uncommon_bg = load("res://assets/art/ui/UI backgrounds/uncommon_bg.png")
@onready var rare_bg = load("res://assets/art/ui/UI backgrounds/rare_bg.png")
@onready var legendary_bg = load("res://assets/art/ui/UI backgrounds/legendary_bg.png")
@onready var ethereal_bg = load("res://assets/art/ui/UI backgrounds/ethereal_bg.png")
@onready var common_healthBG = load("res://assets/art/ui/UI backgrounds/common_healthBG.png")
@onready var uncommon_healthBG = load("res://assets/art/ui/UI backgrounds/uncommon_healthBG.png")
@onready var rare_healthBG = load("res://assets/art/ui/UI backgrounds/rare_healthBG.png")
@onready var legendary_healthBG = load("res://assets/art/ui/UI backgrounds/legendary_healthBG.png")
@onready var ethereal_healthBG = load("res://assets/art/ui/UI backgrounds/ethereal_healthBG.png")
@onready var heart = load("res://assets/art/ui/UI backgrounds/heart.png")
@onready var hearts_2 = load("res://assets/art/ui/UI backgrounds/hearts 2.png")
@onready var hearts_3 = load("res://assets/art/ui/UI backgrounds/hearts 3.png")
@onready var effect_bg = $Rarity_Bg
@onready var title = $Card_Name
@onready var duration = $Effect_Duration
@onready var effect = $Effect_Description
@onready var effect_health_bg = $Health_BG

# UI and Player interaction variables
@onready var stamina_fill : TextureProgressBar = get_node("Stamina Bar/TextureProgressBar")
@onready var player_node : CharacterBody2D = get_node("../../../Player")
@onready var health_fills = []

# Called when the node enters the scene tree for the first time.
func _ready():
	player_node.stamina_update.connect(update_stamina)
	player_node.health_update.connect(update_health)
	health_fills.append(get_node("Hearts/BigTextureProgressBar"))
	health_fills.append(get_node("Hearts/MediumTextureProgressBar"))
	health_fills.append(get_node("Hearts/SmallTextureProgressBar"))

# This will be called like every physics process lol
func update_stamina(new_stamina, max_stamina):
	stamina_fill.value = (new_stamina / max_stamina) * 100

# This func expects floats such as 1.25, 1.5, 2.75, etc
func update_health(new_health):
	var health_as_int: int = clamp(floor(new_health), 0, 3)
	print (health_as_int)
	var x; var y; var z;
	# what in the world is this? -BC
	match health_as_int:
		3: 
			x = 100; y = 100; z = 100
		2:
			x = 100; y = 100; z = (new_health - 2) * 100
		1:
			x = 100; y = (new_health - 1) * 100; z = 0 
		0:
			x = (new_health - 0) * 100; y = 0; z = 0
	health_fills[0].value = x
	health_fills[1].value = y
	health_fills[2].value = z

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
					effect_health_bg.texture = ethereal_healthBG
					title.add_theme_color_override("font_color",Color("00e7ff"))
					duration.add_theme_color_override("font_color",Color("004175"))
					effect.add_theme_color_override("font_color",Color("004175"))
				Card.CARD_RARITY.COMMON:
					effect_bg.texture = common_bg
					effect_health_bg.texture = common_healthBG
					title.add_theme_color_override("font_color",Color("c7c7c7"))
					duration.add_theme_color_override("font_color",Color("272727"))
					effect.add_theme_color_override("font_color",Color("272727"))
				Card.CARD_RARITY.UNCOMMON:
					effect_bg.texture = uncommon_bg
					effect_health_bg.texture = uncommon_healthBG
					title.add_theme_color_override("font_color",Color("ff5700"))
					duration.add_theme_color_override("font_color",Color("640505"))
					effect.add_theme_color_override("font_color",Color("640505"))
				Card.CARD_RARITY.RARE:
					effect_bg.texture = rare_bg
					effect_health_bg.texture = rare_healthBG
					title.add_theme_color_override("font_color",Color("7500ff"))
					duration.add_theme_color_override("font_color",Color("400040"))
					effect.add_theme_color_override("font_color",Color("400040"))
				Card.CARD_RARITY.LEGENDARY:
					effect_bg.texture = legendary_bg
					effect_health_bg.texture = legendary_healthBG
					title.add_theme_color_override("font_color",Color("ff0058"))
					duration.add_theme_color_override("font_color",Color("750027"))
					effect.add_theme_color_override("font_color",Color("750027"))
		else:
			title.text = ""
			effect.text = "Deck Empty"
				
	duration.text = "%2.1f" %(round(DeckManager.timer.get_time_left() * 10) / 10)


