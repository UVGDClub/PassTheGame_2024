class_name Eater extends Enemies

@onready var body = $Body
@onready var face : Sprite2D = $EaterFace
@export var speed : float = 100
@export var oscillation_amplitude = 1.5
@export var change_direction_weight = 0.05

const eater_body = preload("res://src/enemies/eater/eater_body.tscn")
const MAX_BODIES = 10
const POSITION_DELAY = 5

var facing_frame = 0
var facing_dir = Vector2.DOWN

var bodies = []
var positions = []
const MAX_POSITIONS_LENGTH = MAX_BODIES * POSITION_DELAY

func _ready():
	for i in range(0, 10):
		add_body()
	positions.resize(MAX_POSITIONS_LENGTH)
	positions.fill(self.position)

func on_body_entered(body : Node2D):
	pass
	
func add_body() -> Node:
	var new_eater_body = eater_body.instantiate()
	var eater_collider : Area2D = new_eater_body.get_child(0)
	eater_collider.connect("area_entered", on_body_entered)
	body.add_child(new_eater_body)
	bodies.append(new_eater_body)
	return new_eater_body

func _physics_process(delta):
	var player = get_tree().get_first_node_in_group("Player")
	if player == null: return
	
	var target = (player.position - self.position).normalized()
	var dir = facing_dir.slerp(target, change_direction_weight)
	facing_dir = dir.normalized()
	
	var perpendicular_direction = dir.rotated(PI / 2)
	var wiggle_amount = oscillation_amplitude * sin(Time.get_ticks_msec() * 0.001)
	var wiggle_movement = perpendicular_direction * wiggle_amount
	
	var movement : Vector2 = facing_dir * speed * delta + wiggle_movement
	self.global_position += movement
	
	face_direction(target)
	
	positions.push_front(self.global_position)

	for i in range(1, len(bodies)):
		bodies[i].global_position  = positions[i * POSITION_DELAY]
	if len(positions) > MAX_POSITIONS_LENGTH:
		positions.pop_back()

func face_direction(dir : Vector2):
	var angle = dir.angle() + PI / 2 + 2 * PI
	var flipped = angle < 2 * PI or angle > 3 * PI
	# ensure the angle is within 0 (up) to pi (down)
	angle = abs(fmod(angle, 2 * PI))
	
	if angle < PI / 8 or angle > 15 * PI / 8:
		facing_frame = 4
		flipped = false
	elif angle < 3 * PI / 8 or angle > 13 * PI / 8:
		facing_frame = 3
	elif angle < 5 * PI / 8 or angle > 11 * PI / 8:
		facing_frame = 2
	elif angle < 7 * PI / 8 or angle > 9 * PI / 8:
		facing_frame = 1
	elif angle < 9 * PI / 8:
		facing_frame = 0
		flipped = false
	
	face.frame = facing_frame
	face.flip_h = flipped
