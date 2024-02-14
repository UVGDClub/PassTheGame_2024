class_name SuperSpeedCard extends Card

@export var super_speed_length: float = 10.0
@export var speed_increase: float = 200


func play() -> void:
	player = DeckManager.get_tree().get_nodes_in_group("Player")[0]
	player.MAX_WALK_VEL += speed_increase
	await DeckManager.get_tree().create_timer(super_speed_length).timeout
	player.MAX_WALK_VEL -= speed_increase
