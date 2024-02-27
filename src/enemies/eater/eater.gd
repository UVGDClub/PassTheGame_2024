class_name Eater extends Enemies

@onready var body = $Body
@onready var face : Sprite2D = $EaterFace
@onready var state_machine : StateMachine = $StateMachine

@export var speed : float = 100
@export var oscillation_amplitude = 1.5
@export var change_direction_weight = 0.05
@export var health_per_body = 10
@export var bodies_left_when_dead = 3

const eater_body = preload("res://src/enemies/eater/eater_body.tscn")
const MAX_BODIES = 10
const POSITION_DELAY = 5
const MAX_POSITIONS_LENGTH = MAX_BODIES * POSITION_DELAY

var facing_dir = Vector2.DOWN
var bodies = []
var positions = []

func _ready():
	var body_count = MAX_BODIES
	for i in range(0, body_count):
		add_body()
	health = health_per_body * body_count
	positions.resize(MAX_POSITIONS_LENGTH)
	positions.fill(self.position)

func on_body_entered(area : Area2D):
	super._on_hurtbox_area_entered(area)
	print("going from ", health/health_per_body, " to ", len(bodies))
	var start_index = ceil(health/health_per_body)
	var end_index = len(bodies)
	# Destroy bodies whenever we lose the proportionate amount of health
	for _i in range(start_index, end_index):
		var body = bodies.pop_back()
		body.queue_free()

func add_body() -> Node:
	var new_eater_body = eater_body.instantiate()
	var eater_collider : Area2D = new_eater_body.get_child(0)
	eater_collider.connect("area_entered", on_body_entered)
	body.add_child(new_eater_body)
	bodies.append(new_eater_body)
	return new_eater_body

func _process(delta):
	state_machine.process(delta)
	var cur_state = $StateMachine.current_state
	$State.text = "NULL" if cur_state == null else cur_state.name

func _physics_process(delta):
	
	state_machine.physics_process(delta)
	positions.push_front(self.global_position)

	for i in range(1, len(bodies)):
		bodies[i].global_position  = positions[i * POSITION_DELAY]
	if len(positions) > MAX_POSITIONS_LENGTH:
		positions.pop_back()

func set_all_bodies_position(position : Vector2):
	self.position = position
	positions.fill(position)

func hide_bodies():
	face.visible = false
	for body in bodies:
		body.visible = false
		# TODO disable collider
	
func show_bodies():
	face.visible = true
	for body in bodies:
		body.visible = true
		# TODO enable collider
