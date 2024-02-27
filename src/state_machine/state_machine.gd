# how to use:
# state machine node should be a child of its host node
# add a node for state as a child and attach a script that extends State 
# (see player)

extends Node
class_name StateMachine

@export var initial_state : State

var current_state : State
var states : Dictionary = {}

func _ready():
	for child in get_children():
		if child is State:
			states[child.name] = child
			child.state_machine = self
			child.host = get_parent()
	
	if initial_state:
		initial_state.enter()
		current_state = initial_state

func process(delta):
	if current_state:
		current_state.process(delta)

func physics_process(delta):
	if current_state:
		current_state.physics_process(delta)
		current_state.check_transition()

func transition_states(new_state_name):
	print("Transitioning to ", new_state_name)
	var new_state = states.get(new_state_name)
	if not new_state:
		return
	
	if new_state == current_state:
		return
	
	var old_state = current_state
	current_state = new_state
	
	
	if old_state:
		old_state.exit(new_state_name)
		new_state.enter(old_state.name)
	else:
		new_state.enter()
	
