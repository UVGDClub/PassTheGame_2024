extends State

@onready var combo_bar : TextureProgressBar = get_node("../../ComboBar")
var t : Tween

func enter(prev_state_name=null):
	host.is_input_chaining = true
	combo_bar.tint_progress = Color.WHITE
	var dash_dir = host.get_local_mouse_position().normalized()
	if dash_dir == Vector2.ZERO:
		dash_dir = Vector2.RIGHT
	host.last_input_vect = dash_dir
	t = create_tween()
	host.velocity = dash_dir * host.DASH_START_VEL
	t.tween_property(host, "velocity", host.DASH_END_VEL * dash_dir, host.dash_time)
	host.update_animation("dash", dash_dir)

func exit(new_state_name=null):
	host.velocity = Vector2.ZERO
	host.dash_cooldown_timer = host.dash_cooldown
	if host.is_input_chaining:
		host.input_chain_buffer_timer = host.input_chain_buffer
		host.input_chain_buffer = host.input_chain_buffer * 0.8
		host.last_input_chain_was_attack = false

func process(delta):
	pass

func physics_process(delta):
	if host.dash_just_pressed or host.attack_just_pressed:
		host.is_input_chaining = false

func check_transition():
	if not t.is_running():
		state_machine.transition_states("Walk")
