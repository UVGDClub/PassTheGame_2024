class_name SuperDashCard extends Card

@export var super_dash_length: float = 8.0
@export var dash_time_increase: float = 0.1


func play() -> void:
	player.dash_time_offset = dash_time_increase
	await get_tree().create_timer(super_dash_length).timeout
	player.dash_time_offset = 0.0
