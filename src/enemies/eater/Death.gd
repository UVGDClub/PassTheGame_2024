extends State

@onready var die_sfx = $"../../DieSFX"

# eater is the parent of the state machine (which this is a child of)
@onready var death_timer = $DeathTimer
@onready var death_particles = $DeathParticles

func enter(prev_state_name=null):
	for body in host.bodies:
		body.visible = false
	host.visible = false;
	set_death_timer()
	die_sfx.play()
	death_particles.emitting = true
	death_particles.global_position = host.global_position
	

func set_death_timer():
	death_timer.start(0.5)

func exit(new_state_name=null):
	pass

func process(delta):
	pass

func physics_process(delta):
	pass

func check_transition():
	pass

func _on_death_timer_timeout():
	host.handle_death();
