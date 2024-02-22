class_name Stronger_Attack extends PassiveCard

func play() -> void:
	await DeckManager.timer.start(duration)


func consume() ->void:
	player.base_attack += 2
	DeckManager.timer.start(0.1)
	
func apply_passive() -> void:
	player.attack_dmg += 10
