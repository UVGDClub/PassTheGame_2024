extends CharacterBody2D

@onready var state_machine = $StateMachine

const MAX_WALK_VEL = 200
const WALK_ACC = MAX_WALK_VEL / 0.1 # time to reach full speed in seconds
const WALK_TURN_ACC = MAX_WALK_VEL / 0.04
const IDLE_FRICTION = MAX_WALK_VEL / 0.05

const INPUT_CHAIN_STARTING_BUFFER = 1
const DASH_COOLDOWN = 1

const DASH_START_VEL = 600
const DASH_END_VEL = 1100
const DASH_TIME = 0.15

const ATTACK_START_VEL = 300
const ATTACK_END_VEL = 400
const ATTACK_TIME = 0.2

# I am... sorry
var input_vect = Vector2.ZERO
var dash_just_pressed = false
var attack_just_pressed = false
#

var is_input_chaining = false :
	set(value):
		if not value:
			dash_cooldown_timer = DASH_COOLDOWN
			input_chain_buffer = INPUT_CHAIN_STARTING_BUFFER
		is_input_chaining = value

var last_input_chain_was_attack = false
var input_chain_buffer = INPUT_CHAIN_STARTING_BUFFER

var input_chain_buffer_timer = 0
var dash_cooldown_timer = 0

func _physics_process(delta):
	get_input()
	state_machine.physics_process(delta)
	move_and_slide()
	
	update_debug_labels()

func get_input():
	input_vect = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	dash_just_pressed = Input.is_action_just_pressed("ui_accept")
	attack_just_pressed = Input.is_action_just_pressed("ui_focus_next")

func update_debug_labels():
	$temp_StateLabel.text = state_machine.current_state.name
	if is_input_chaining:
		$temp_InputChainLabel.text = "Chain Buffer: " + str(round(input_chain_buffer_timer * 100) / 100)
	else:
		$temp_InputChainLabel.text = "Cooldown: " + str(round(dash_cooldown_timer * 100) / 100)
