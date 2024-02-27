extends State

@export var burrow_timer_range : Vector2 = Vector2(3, 5)
@export var attack_range : float = 30
@export var lose_player_distance : float = 500

@onready var burrow_timer : Timer = $BurrowTimer

func enter(prev_state_name=null):
	set_burrow_timer()

func set_burrow_timer():
	var wait_time = randf_range(burrow_timer_range.x, burrow_timer_range.y)
	burrow_timer.start(wait_time)
	
func exit(new_state_name=null):
	burrow_timer.stop()

func process(delta):
	pass

func _on_burrow_timer_timeout():
	state_machine.transition_states("Burrow")

func physics_process(delta):
	var player = get_tree().get_first_node_in_group("Player")
	if player == null: return
	
	var target = (player.position - host.position).normalized()
	var dir = host.facing_dir.slerp(target, host.change_direction_weight)
	host.facing_dir = dir.normalized()
	
	var perpendicular_direction = dir.rotated(PI / 2)
	var wiggle_amount = host.oscillation_amplitude * sin(Time.get_ticks_msec() * 0.001)
	var wiggle_movement = perpendicular_direction * wiggle_amount
	
	var movement : Vector2 = host.facing_dir * host.speed * delta + wiggle_movement
	host.global_position += movement
	
	host.face_direction(target)

func check_transition():
	var player : Player = get_tree().get_first_node_in_group("Player")
	if player == null: return
	var vec_to_player = player.position - host.position
	var dist : float = vec_to_player.length()
	if dist <= attack_range:
		state_machine.transition_states("Attack")
		
	if dist >= lose_player_distance:
		state_machine.transition_states("Wander")

