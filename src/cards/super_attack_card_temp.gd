class_name SuperAttackCard extends Card

@export var super_attack_length: float = 4.0
@export var attack_length_increase: float = 0.15


func play() -> void:
	player = DeckManager.get_tree().get_nodes_in_group("Player")[0]
	player.attack_time += attack_length_increase
	await DeckManager.get_tree().create_timer(super_attack_length).timeout
	player.attack_time -= attack_length_increase
