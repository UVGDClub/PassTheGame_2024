class_name Eater extends Enemies

@onready var body = $Body
@onready var face : Sprite2D = $EaterFace
@onready var state_machine : StateMachine = $StateMachine
@onready var hit_cooldown : Timer = $HitCooldown

@export var speed : float = 100
@export var oscillation_amplitude = 1.5
@export var change_direction_weight = 0.05
@export var health_per_body = 5
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
	max_health = health_per_body * body_count
	health = max_health
	positions.resize(MAX_POSITIONS_LENGTH)
	positions.fill(self.position)

func on_body_entered(area : Area2D):
	if not hit_cooldown.is_stopped(): return
	super._on_hurtbox_area_entered(area)
	if health <= 0:
		super.handle_death()

	var start_index = ceil(health / health_per_body)
	var end_index = len(bodies)
	if end_index > bodies_left_when_dead:
		# Destroy bodies whenever we lose the proportionate amount of health
		for _i in range(start_index, end_index):
			var body_to_remove = bodies.pop_back()
			if body_to_remove != null: 
				body_to_remove.queue_free()
	hit_cooldown.start()

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
	$Health.text = str(health) + "/" + str(max_health)

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
	for body_to_hide in bodies:
		body_to_hide.visible = false
		# TODO disable collider
	
func show_bodies():
	face.visible = true
	for body_to_show in bodies:
		body_to_show.visible = true
		# TODO enable collider

func face_direction(dir : Vector2):
	var angle = dir.angle() + PI / 2 + 2 * PI
	var flipped = angle < 2 * PI or angle > 3 * PI
	# ensure the angle is within 0 (up) to pi (down)
	angle = abs(fmod(angle, 2 * PI))
	
	var facing_frame = 0
	
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

# https://github.com/godotengine/godot/pull/43103#issuecomment-1320092325
func random_point_on_ring(outer_radius: float, inner_radius := 0.0) -> Vector2:
	return Vector2.RIGHT.rotated(randf() * TAU) * sqrt(randf_range(pow(1 - (outer_radius - inner_radius) / outer_radius, 2), 1)) * outer_radius

func on_face_hit_area(area : Area2D):
	print("Tryna deal damage")
	if area.is_in_group("Player"):
		print("Dealing damage to player")
		# TODO actually deal the damage
