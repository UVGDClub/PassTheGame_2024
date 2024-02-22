class_name Stim_Card extends ConsumeCard

func play() -> void:
	await DeckManager.timer.timeout


func consume() -> void:
	player.attack_dmg *= 2
	DeckManager.timer.start(0.1)
	await DeckManager.get_tree().create_timer(consume_duration).timeout
	player.attack_dmg /= 2
