extends Node
class_name State

@onready var state_machine : StateMachine

@onready var host : Node

func enter(prev_state_name=null):
	pass

func exit(new_state_name=null):
	pass

func process(delta):
	pass

func physics_process(delta):
	pass

func check_transition():
	pass
