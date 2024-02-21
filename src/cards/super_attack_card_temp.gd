class_name SuperAttackCard extends Card


@export var attack_length_increase: float = 0.15


func play() -> void:
	player = DeckManager.get_tree().get_nodes_in_group("Player")[0]
	player.attack_time += attack_length_increase
	await DeckManager.timer.timeout
	player.attack_time -= attack_length_increase
	if consumed:
		player.attack_dmg -= 2
		DeckManager.remove_card(self)
		
func consume() -> void:
	if not consumed:
		consumed = true
		player.attack_dmg += 2
		DeckManager.timer.start(duration)
