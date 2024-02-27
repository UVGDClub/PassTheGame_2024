extends State

@export var see_player_range = 300
var player : Player

func enter(prev_state_name=null):
	player = get_tree().get_first_node_in_group("Player")

func exit(new_state_name=null):
	pass

func process(delta):
	pass

func physics_process(delta):
	# Pick random points in a circle to wander to every second or two
	# using host.random_point_on_ring with the center point being the
	# center of the current room
	pass

func check_transition():
	var dist_to_player = (player.position - host.position).length()
	if dist_to_player <= see_player_range:
		state_machine.transition_states("Chase")
