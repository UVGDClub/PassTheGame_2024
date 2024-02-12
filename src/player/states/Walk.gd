extends State

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
	if host.is_input_chaining:
		host.input_chain_buffer_timer -= delta
		if host.input_chain_buffer_timer <= 0:
			host.is_input_chaining = false
	else:
		host.dash_cooldown_timer -= delta

func check_transition():
	if host.dash_just_pressed:
		if (not host.is_input_chaining and host.dash_cooldown_timer <= 0) or \
		 (host.is_input_chaining and host.last_input_chain_was_attack):
			state_machine.transition_states("Dash")
		elif host.is_input_chaining:
			host.is_input_chaining = false
	
	elif host.attack_just_pressed:
		if (not host.is_input_chaining and host.dash_cooldown_timer <= 0) or \
		 (host.is_input_chaining and not host.last_input_chain_was_attack):
			state_machine.transition_states("Attack")
		elif host.is_input_chaining:
			host.is_input_chaining = false
