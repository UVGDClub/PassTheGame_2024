class_name SuperSpeedCard extends Card


@export var speed_increase: float = 100


func play() -> void:
	player = DeckManager.get_tree().get_nodes_in_group("Player")[0]
	player.MAX_WALK_VEL += speed_increase
	await DeckManager.timer.timeout
	player.MAX_WALK_VEL -= speed_increase
	if consumed:
		player.MAX_WALK_VEL -= speed_increase
		DeckManager.remove_card(self)
		
func consume() -> void:
	if not consumed:
		consumed = true
		player.MAX_WALK_VEL += speed_increase
		DeckManager.timer.start(duration)
