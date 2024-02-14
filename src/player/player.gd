class_name Player extends CharacterBody2D

@onready var state_machine = $StateMachine
@onready var flip = $Flip
@onready var animation_player = $AnimationPlayer

const MAX_WALK_VEL = 200
const WALK_ACC = MAX_WALK_VEL / 0.1 # time to reach full speed in seconds
const WALK_TURN_ACC = MAX_WALK_VEL / 0.04
const IDLE_FRICTION = MAX_WALK_VEL / 0.05

const INPUT_CHAIN_STARTING_BUFFER = 1
const DASH_COOLDOWN = 1

const DASH_START_VEL = 1000
const DASH_END_VEL = 1200
const DASH_TIME = 0.1

const ATTACK_START_VEL = 300
const ATTACK_END_VEL = 400
const ATTACK_TIME = 0.2

# I am... sorry
var input_vect = Vector2.ZERO
var dash_just_pressed = false
var attack_just_pressed = false

var last_input_vect = Vector2.RIGHT
#

# Card controlled offsets
var dash_time_offset = 0.0
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
	input_vect = Input.get_vector("left", "right", "up", "down")
	dash_just_pressed = Input.is_action_just_pressed("dash")
	attack_just_pressed = Input.is_action_just_pressed("attack")

func update_animation(type, vect):
	if vect == Vector2.ZERO:
		return
	
	if (flip.scale.x < 0 and vect.x > 0) or (flip.scale.x > 0 and vect.x < 0):
		flip.scale.x *= -1
	vect.x = abs(vect.x)
	var vect_angle = Vector2.RIGHT.angle_to(vect)
	
	var animation_name
	match type:
		"idle":
			if vect_angle < -3 * PI / 8:
				animation_name = "IdleUp"
			elif vect_angle > 3 * PI / 8:
				animation_name = "IdleDown"
			elif vect_angle < -1 * PI / 8:
				animation_name = "IdleUpSide"
			elif vect_angle > 1 * PI / 8:
				animation_name = "IdleDownSide"
			else:
				animation_name = "IdleSide"
		
		"walk":
			if vect_angle < -3 * PI / 8:
				animation_name = "WalkUp"
			elif vect_angle > 3 * PI / 8:
				animation_name = "WalkDown"
			elif vect_angle < -1 * PI / 8:
				animation_name = "WalkUpSide"
			elif vect_angle > 1 * PI / 8:
				animation_name = "WalkDownSide"
			else:
				animation_name = "WalkSide"
		
		"dash":
			if vect_angle < -3 * PI / 8:
				animation_name = "DashUp"
			elif vect_angle > 3 * PI / 8:
				animation_name = "DashDown"
			elif vect_angle < -1 * PI / 8:
				animation_name = "DashUpSide"
			elif vect_angle > 1 * PI / 8:
				animation_name = "DashDownSide"
			else:
				animation_name = "DashSide"
		
		"attack":
			if vect_angle < -3 * PI / 8:
				animation_name = "AttackUp"
			elif vect_angle > 3 * PI / 8:
				animation_name = "AttackDown"
			elif vect_angle < -1 * PI / 8:
				animation_name = "AttackUpSide"
			elif vect_angle > 1 * PI / 8:
				animation_name = "AttackDownSide"
			else:
				animation_name = "AttackSide"
	
	if animation_name and animation_player.current_animation != animation_name:
		animation_player.play(animation_name)


func update_debug_labels():
	$temp_StateLabel.text = "State: " + state_machine.current_state.name
	$temp_AnimationLabel.text = "Animation: " + animation_player.current_animation
	if is_input_chaining:
		$temp_InputChainLabel.text = "Chain Buffer: " + str(round(input_chain_buffer_timer * 100) / 100)
	else:
		$temp_InputChainLabel.text = "Cooldown: " + str(round(dash_cooldown_timer * 100) / 100)


func _on_card_pickup_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	var card_pickup: Card = area.get_parent()
	if card_pickup is Card:
		DeckManager.add_card(card_pickup)
		card_pickup.visible = false
		card_pickup.position = Vector2(69420, 69420)
