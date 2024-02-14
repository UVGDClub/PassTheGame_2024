class_name SuperDashCard extends Card

@export var super_dash_length: float = 4.0
@export var dash_time_increase: float = 0.4


func play() -> void:
	player = DeckManager.get_tree().get_nodes_in_group("Player")[0]
	player.dash_time += dash_time_increase
	await DeckManager.get_tree().create_timer(super_dash_length).timeout
	player.dash_time -= dash_time_increase
