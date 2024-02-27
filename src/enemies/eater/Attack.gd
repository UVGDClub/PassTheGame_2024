extends State

@export var speed_multiplier : float = 2.0
@export var speed_reduction_multiplier : float = 1

var player : Player
var target : Vector2
var cur_speed_multiplier : float = speed_multiplier
func enter(prev_state_name=null):
	cur_speed_multiplier = speed_multiplier
	player = get_tree().get_first_node_in_group("Player")
	target = (player.position - host.position).normalized()
	host.facing_dir = target

func exit(new_state_name=null):
	pass

func process(delta):
	pass

func physics_process(delta):
	var movement : Vector2 = target * host.speed * delta * cur_speed_multiplier
	cur_speed_multiplier -= delta * speed_reduction_multiplier
	host.global_position += movement

func check_transition():
	if target == null or player == null:
		state_machine.transition_states("Chase")
	if cur_speed_multiplier < 1:
		state_machine.transition_states("Chase")
