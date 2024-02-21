class_name SuperDashCard extends Card


@export var dash_time_increase: float = 0.2


func play() -> void:
	player = DeckManager.get_tree().get_nodes_in_group("Player")[0]
	player.dash_time += dash_time_increase
	await DeckManager.timer.timeout
	player.dash_time -= dash_time_increase
	if consumed:
		player.dash_time -= dash_time_increase
		DeckManager.remove_card(self)
		
func consume() -> void:
	if not consumed:
		consumed = true
		player.dash_time += dash_time_increase
		DeckManager.timer.start(duration)
