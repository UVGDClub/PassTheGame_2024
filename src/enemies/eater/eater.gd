class_name Eater extends Enemies

@onready var body = $Body
@onready var face : Sprite2D = $GlorbFace
@export var speed : float = 50
const max_dist = 1
const eater_body = preload("res://src/enemies/eater/eater_body.tscn")
const MAX_BODIES = 10
const POSITION_DELAY = 10
# 0 for down, 1 for down-right, etc. 8 total.
var facing_quadrant = 0

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
	
func add_body():
	var new_eater_body = eater_body.instantiate()
	var eater_collider : Area2D = new_eater_body.get_child(0)
	eater_collider.connect("area_entered", on_body_entered)
	body.add_child(new_eater_body)
	bodies.append(new_eater_body)

func _physics_process(delta):
	var player = get_tree().get_first_node_in_group("Player")
	if player == null: return
	var dir = (player.position - self.position).normalized()
	var perpendicular_direction = dir.rotated(PI / 2)
	var wiggle_amount = sin(Time.get_ticks_msec() * 0.001)
	var wiggle_movement = perpendicular_direction * wiggle_amount
	
	var movement : Vector2 = dir.normalized() * speed * delta + wiggle_movement
	
	self.global_position += movement
	
	var angle = dir.angle()
	angle = fmod(angle + 2 * PI, 2 * PI) # Ensure angle is within 0 to 2*PI range
	facing_quadrant = int(angle / (PI / 4))
	
	
	face.flip_h = facing_quadrant < 6 or facing_quadrant > 9
	var frame = 0
	match facing_quadrant:
		0, 1: 
			frame = 0 # South
		2: 
			frame = 1 # South-East
		3, 4: 
			frame = 2 # East
		5: 
			frame = 3 # North-East
		6, 7:
			frame = 4 # North
	face.frame = frame
	
	positions.push_front(self.global_position)

	for i in range(1, len(bodies)):
		bodies[i].global_position  = positions[i * POSITION_DELAY]
	if len(positions) > MAX_POSITIONS_LENGTH:
		positions.pop_back()
"""
class_name Eater extends Enemies

@onready var body = $Body
@export var speed : float = 30
const MAX_DIST = 10
const eater_body = preload("res://src/enemies/eater/eater_body.tscn")
const MAX_BODIES = 10

var bodies = []

func _ready():
	bodies.append(self)
	for i in range(0, 10):
		add_body()

func on_body_entered(body : Node2D):
	print("body entered")
	pass
	
func add_body():
	var new_eater_body = eater_body.instantiate()
	var eater_collider : Area2D = new_eater_body.get_child(0)
	eater_collider.connect("area_entered", on_body_entered)
	body.add_child(new_eater_body)
	bodies.append(new_eater_body)

func _physics_process(delta):
	var dir = Vector2.RIGHT
	var perpendicular_direction = dir.rotated(PI / 2)
	var wiggle_amount = sin(Time.get_ticks_msec() * 0.001)
	var wiggle_movement = perpendicular_direction * wiggle_amount
	
	var movement = dir.normalized() * speed * delta + wiggle_movement
	
	self.global_position += movement
	$RigidBody2D.linear_velocity = movement
	return
	
	for i in range(1, len(bodies)):
		var target_pos : Vector2 = bodies[i-1].position
		var cur_pos : Vector2 = bodies[i].position
		var dist = cur_pos.distance_to(target_pos)
		if dist > MAX_DIST:
			var direction : Vector2 = (target_pos - cur_pos).normalized()
			# var body_speed = (target_pos - cur_pos).length()
			
			var move_amount = min(speed * delta, dist - MAX_DIST)
			bodies[i].global_position += direction * move_amount
"""
