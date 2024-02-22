class_name Heal_Card extends ConsumeCard


func play() -> void:
	await DeckManager.timer.timeout


func consume() -> void:
	player.health += 1
	DeckManager.timer.start(0.1)
	
