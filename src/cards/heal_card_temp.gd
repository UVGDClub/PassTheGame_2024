class_name Heal_Card extends ConsumeCard


func play() -> void:
	player = DeckManager.get_tree().get_nodes_in_group("Player")[0]
	await DeckManager.timer.start(duration)


func consume() -> void:
	player.health += 1
	DeckManager.timer.start(0.1)
	
