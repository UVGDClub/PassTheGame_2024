extends State

@export var surface_timer_range : Vector2 = Vector2(1, 2)

# eater is the parent of the state machine (which this is a child of)
@onready var surface_timer : Timer = $SurfaceTimer

func enter(prev_state_name=null):
	for body in host.bodies:
		body.visible = false
	set_surface_timer()

func set_surface_timer():
	var wait_time = randf_range(surface_timer_range.x, surface_timer_range.y)
	print("waiting for ", wait_time)
	surface_timer.start(wait_time)

func _on_surface_timer_timeout():
	print("Surfacing!")
	state_machine.transition_states("Surface")

func exit(new_state_name=null):
	pass

func process(delta):
	pass

func physics_process(delta):
	pass

func check_transition():
	pass

