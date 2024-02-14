class_name NoDashCooldownEtherealCard extends EtherealCard

@export var length: float = 12.0


func play() -> void:
	player = DeckManager.get_tree().get_nodes_in_group("Player")[0]
	var prev_player_dash_cooldown = player.dash_cooldown
	player.dash_cooldown = 0
	await DeckManager.get_tree().create_timer(length).timeout
	player.dash_cooldown -= prev_player_dash_cooldown
