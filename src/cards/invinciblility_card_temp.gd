class_name InvincibilityCard extends Card

@export var length: float = 10.0


func play() -> void:
	player = DeckManager.get_tree().get_nodes_in_group("Player")[0]
	player.hurtbox.monitorable = false
	await DeckManager.get_tree().create_timer(length).timeout
	player.hurtbox.monitorable = true
