class_name SuperSpeedCard extends Card

@export var super_speed_length: float = 10.0
@export var speed_increase: float = 200


func play() -> void:
	player = DeckManager.get_tree().get_nodes_in_group("Player")[0]
	player.MAX_WALK_VEL += speed_increase
	await DeckManager.timer.timeout
	player.MAX_WALK_VEL -= speed_increase
	if consumed:
		DeckManager.remove_card(self)
		
func consume() -> void:
	if not consumed:
		consumed = true
		DeckManager.timer.start(duration)
