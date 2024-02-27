extends State

@export var surface_dist_range = Vector2(20, 200)

var spawn_point = Vector2.ZERO
@onready var dig_particles : CPUParticles2D = $DigParticles
@onready var dig_delay_timer : Timer = $DigDelayTimer

func enter(prev_state_name=null):
	var player : Player = get_tree().get_first_node_in_group("Player")
	var rand_point = host.random_point_on_ring(surface_dist_range.x, surface_dist_range.y)
	spawn_point = player.position + rand_point
	host.set_all_bodies_position(spawn_point)
	dig_delay_timer.start()
	dig_particles.global_position = host.global_position
	dig_particles.emitting = true

func exit(new_state_name=null):
	dig_particles.emitting = false
	pass

func process(delta):
	pass

func physics_process(delta):
	pass

func check_transition():
	pass


func _on_dig_delay_timer_timeout():
	host.set_all_bodies_position(spawn_point)
	host.show_bodies()
		
	state_machine.transition_states("Chase")
