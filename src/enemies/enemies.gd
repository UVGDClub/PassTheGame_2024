class_name Enemies extends Node


@onready var pick_up = preload("res://src/cards/card_pack/card_pack_pickup.tscn")
@export var health: float
@export var hit_cooldown : Timer
# Called when the node enters the scene tree for the first time.
func _ready():
	create_timer()
	
func create_timer():
	hit_cooldown = Timer.new()
	add_child(hit_cooldown)
	hit_cooldown.one_shot = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# if the timer ever gets destroyed just remake it
	if hit_cooldown == null:
		create_timer()
	if health <= 0:
		handle_death()

func handle_death():
	spawn_card()

func spawn_card():
	var new_pick_up = pick_up.instantiate()
	new_pick_up.global_position = self.global_position
	get_parent().add_child(new_pick_up)
	queue_free()

func _on_hurtbox_area_entered(area):
	if not hit_cooldown.is_stopped(): return
	health -= area.hit_damage
	print("damaged " + str(area.hit_damage))
	hit_cooldown.start()
