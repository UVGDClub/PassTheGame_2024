extends State

@onready var combo_bar : TextureProgressBar = get_node("../../ComboBar")
#signal combo_update(curr_buff)

func enter(prev_state_name=null):
	pass

func exit(new_state_name=null):
	pass

func process(delta):
	pass

func physics_process(delta):
	compute_axis("x", delta)
	compute_axis("y", delta)
	if host.input_vect != Vector2.ZERO:
		host.last_input_vect = host.input_vect
		host.update_animation("walk", host.input_vect)
	else:
		host.update_animation("idle", host.last_input_vect)
	update_stats(delta)
	update_timers(delta)

func compute_axis(axis, delta):
	if host.input_vect[axis] == 0:
		host.velocity[axis] = move_toward(host.velocity[axis], 0, host.IDLE_FRICTION * delta)
	elif is_turning(axis):
		host.velocity[axis] = move_toward(host.velocity[axis], host.MAX_WALK_VEL * host.input_vect[axis], host.WALK_TURN_ACC * delta)
	else:
		host.velocity[axis] = move_toward(host.velocity[axis], host.MAX_WALK_VEL * host.input_vect[axis], host.WALK_ACC * delta)

func is_turning(axis):
	return (host.input_vect[axis] < 0 and host.velocity[axis] > 0) or \
	 (host.input_vect[axis] > 0 and host.velocity[axis] < 0) 

func update_timers(delta):
	host.dash_cooldown_timer -= delta
	host.attack_cooldown_timer -= delta
	if host.is_input_chaining:
		host.input_chain_buffer_timer -= delta
		combo_bar.value = (host.input_chain_buffer_timer / host.INPUT_CHAIN_STARTING_BUFFER) * 100
		#emit_signal("combo_update", host.input_chain_buffer_timer)
		if host.input_chain_buffer_timer <= 0:
			host.is_input_chaining = false
			combo_bar.value = 0
			#emit_signal("combo_update", 0)
		
		
func update_stats(delta):
	#print("STemAINA?")
	if host.stamina < host.base_stamina:
		host.stamina = host.stamina + host.stamina_regen

	
func check_transition():
	if host.dash_just_pressed:
		if host.is_input_chaining:
			if(( host.last_input_chain_was_attack)and host.stamina >= 10):
				state_machine.transition_states("Dash")
				host.stamina -= 10
			else:
				combo_bar.tint_progress = Color.BLACK
				host.is_input_chaining = false
		if host.dash_cooldown_timer <= 0:
			state_machine.transition_states("Dash")
			host.stamina -= 10
	
	elif host.attack_just_pressed:
		if host.is_input_chaining:
			if(( not host.last_input_chain_was_attack)and host.stamina >= 10):
				state_machine.transition_states("Attack")
				host.stamina -= 10
			else:
				combo_bar.tint_progress = Color.BLACK
				host.is_input_chaining = false
		if host.attack_cooldown_timer <= 0:
			state_machine.transition_states("Attack")
			host.stamina -= 10
