extends State

@onready var dig_particles : CPUParticles2D = $DigParticles
@onready var burrow_delay_timer : Timer = $BurrowDelayTimer

func enter(prev_state_name=null):
	dig_particles.emitting = true
	dig_particles.global_position = host.global_position
	burrow_delay_timer.start()
	pass

func exit(new_state_name=null):
	dig_particles.emitting = false
	host.hide_bodies()

func process(delta):
	var timer_completeness = (burrow_delay_timer.wait_time - burrow_delay_timer.time_left) / burrow_delay_timer.wait_time
	print("timer completeness ", timer_completeness)
	for i in range(0, timer_completeness * len(host.bodies)):
		if i == 0:
			host.face.visible = false
		host.bodies[i].visible = false
	pass

func physics_process(delta):
	pass

func check_transition():
	pass


func _on_burrow_delay_timer_timeout():
	state_machine.transition_states("Hide")
