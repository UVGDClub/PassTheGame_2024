extends State

@export var burrow_timer_range : Vector2 = Vector2(3, 5)
@export var attack_range : float = 30

@onready var burrow_timer : Timer = $BurrowTimer

func enter(prev_state_name=null):
	set_burrow_timer()

func set_burrow_timer():
	var wait_time = randf_range(burrow_timer_range.x, burrow_timer_range.y)
	burrow_timer.start(wait_time)
	
func exit(new_state_name=null):
	pass

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
	
	face_direction(target)

func face_direction(dir : Vector2):
	var angle = dir.angle() + PI / 2 + 2 * PI
	var flipped = angle < 2 * PI or angle > 3 * PI
	# ensure the angle is within 0 (up) to pi (down)
	angle = abs(fmod(angle, 2 * PI))
	
	var facing_frame = 0
	
	if angle < PI / 8 or angle > 15 * PI / 8:
		facing_frame = 4
		flipped = false
	elif angle < 3 * PI / 8 or angle > 13 * PI / 8:
		facing_frame = 3
	elif angle < 5 * PI / 8 or angle > 11 * PI / 8:
		facing_frame = 2
	elif angle < 7 * PI / 8 or angle > 9 * PI / 8:
		facing_frame = 1
	elif angle < 9 * PI / 8:
		facing_frame = 0
		flipped = false
	
	host.face.frame = facing_frame
	host.face.flip_h = flipped


func check_transition():
	return
	var player : Player = get_tree().get_first_node_in_group("Player")
	if player == null: return
	var vec_to_player = player.position - host.position
	var dist : float = vec_to_player.length()
	if dist <= attack_range:
		state_machine.transition_states("Attack")

