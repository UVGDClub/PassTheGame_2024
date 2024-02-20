class_name InvincibilityCard extends Card

@export var length: float = 10.0


func play() -> void:
	player = DeckManager.get_tree().get_nodes_in_group("Player")[0]
	player.hurtbox.monitorable = false
	await DeckManager.timer.timeout
	player.hurtbox.monitorable = true
	if consumed:
		DeckManager.remove_card(self)
		
func consume() -> void:
	if not consumed:
		consumed = true
		DeckManager.timer.start(duration)
