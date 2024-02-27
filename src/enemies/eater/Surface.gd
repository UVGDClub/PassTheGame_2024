extends State

@export var surface_dist_range = Vector2(20, 60)

var spawn_point = Vector2.ZERO
@onready var dig_particles : CPUParticles2D = $DigParticles
@onready var dig_delay_timer : Timer = $DigDelayTimer

# https://github.com/godotengine/godot/pull/43103#issuecomment-1320092325
func random_point_on_ring(outer_radius: float, inner_radius := 0.0) -> Vector2:
	return Vector2.RIGHT.rotated(randf() * TAU) * sqrt(randf_range(pow(1 - (outer_radius - inner_radius) / outer_radius, 2), 1)) * outer_radius

func enter(prev_state_name=null):
	var player : Player = get_tree().get_first_node_in_group("Player")
	var rand_point = random_point_on_ring(surface_dist_range.x, surface_dist_range.y)
	spawn_point = player.position + rand_point
	host.set_all_bodies_position(spawn_point)
	dig_delay_timer.start()
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
