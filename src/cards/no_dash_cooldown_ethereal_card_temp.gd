class_name NoDashCooldownEtherealCard extends EtherealCard

@export var length: float = 12.0


func play() -> void:
	player = DeckManager.get_tree().get_nodes_in_group("Player")[0]
	var prev_player_dash_cooldown = player.dash_cooldown
	player.dash_cooldown = 0
	await DeckManager.timer.timeout
	player.dash_cooldown = prev_player_dash_cooldown
	if consumed:
		player.hit_multiplier = 1.0

		
func consume() -> void:
	if not consumed:
		consumed = true
		player.hit_multiplier = 2.0
		DeckManager.timer.start(duration)
