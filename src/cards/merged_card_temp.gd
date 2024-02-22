class_name MergedCard extends Card

@export var super_attack_length: float = 4.0
@export var attack_length_increase: float = 0.15
@export var super_dash_length: float = 4.0
@export var dash_time_increase: float = 0.4
@export var super_speed_length: float = 10.0
@export var speed_increase: float = 200

# currently merged card doesnt spawn
# but maybe making it spawn and act as a container wouldve been better

var verbose_duration: float = 1.0

func play() -> void:
	player = DeckManager.get_tree().get_nodes_in_group("Player")[0]

	# the merge effect template
	# can be whatever but currently i just added the effect
	# technically this can be made generic by adding a on/off_effect_start in card.gd
	# with less freedom of how things should work

	if merged_list.has("Invincible"):
		player.hurtbox.monitorable = false

	if merged_list.has("4x Attack Distant"):
		player.attack_time += attack_length_increase

	if merged_list.has("2x Speed") && merged_list.has("4x Dash Length"):
		player.MAX_WALK_VEL += speed_increase
		player.DASH_START_VEL *= 1.25
	elif merged_list.has("2x Speed"):
		player.MAX_WALK_VEL += speed_increase

	var prev_player_dash_cooldown: int = player.dash_cooldown
	if merged_list.has("4x Dash Length") && merged_list.has("No Dash Cooldown"):
		player.dash_cooldown = 0
		# and mayber other things like bouncy on hitting wall
	elif merged_list.has("4x Dash Length"):
		player.dash_time += dash_time_increase
	elif merged_list.has("No Dash Cooldown"):
		player.dash_cooldown = 0

	if merged_list.has("4x Dash Length") && merged_list.has("No Dash Cooldown"):
		player.dash_cooldown = 0

	if merged_list.has("4x Dash Length") && merged_list.has("No Dash Cooldown") && merged_list.has("2x Speed"):
		player.set_collision_layer_value(1, false)
		# so that ppl can look for hidden stuff maybe?

	await DeckManager.timer.timeout

	if merged_list.has("Invincible"):
		player.hurtbox.monitorable = true

	if merged_list.has("4x Attack Distant"):
		player.attack_time -= attack_length_increase

	if merged_list.has("2x Speed") && merged_list.has("4x Dash Length"):
		player.MAX_WALK_VEL -= speed_increase
		player.DASH_START_VEL *= 0.8
	elif merged_list.has("2x Speed"):
		player.MAX_WALK_VEL -= speed_increase

	if merged_list.has("4x Dash Length") && merged_list.has("No Dash Cooldown"):
		player.dash_cooldown = prev_player_dash_cooldown
	elif merged_list.has("4x Dash Length"):
		player.dash_time -= dash_time_increase
	elif merged_list.has("No Dash Cooldown"):
		player.dash_cooldown = prev_player_dash_cooldown

	if merged_list.has("4x Dash Length") && merged_list.has("No Dash Cooldown") && merged_list.has("2x Speed"):
		player.set_collision_layer_value(1, true)

	if consumed:
		DeckManager.remove_card(self)
		
func consume() -> void:
	if not consumed:
		consumed = true
		DeckManager.timer.start(duration)
