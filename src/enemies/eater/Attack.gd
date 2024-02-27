extends State

var player : Player
func enter(prev_state_name=null):
	player = get_tree().get_first_node_in_group("Player")

func exit(new_state_name=null):
	pass

func process(delta):
	pass

func physics_process(delta):
	pass

func check_transition():
	pass
