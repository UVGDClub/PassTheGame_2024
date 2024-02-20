class_name SuperAttackCard extends Card

@export var super_attack_length: float = 4.0
@export var attack_length_increase: float = 0.15


func play() -> void:
	player = DeckManager.get_tree().get_nodes_in_group("Player")[0]
	player.attack_time += attack_length_increase
	await DeckManager.timer.timeout
	player.attack_time -= attack_length_increase
	if consumed:
		DeckManager.remove_card(self)
		
func consume() -> void:
	if not consumed:
		consumed = true
		DeckManager.timer.start(duration)
