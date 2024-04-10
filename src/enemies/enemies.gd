class_name Enemies extends Node


@onready var pick_up = preload("res://src/cards/card_pack/card_pack_pickup.tscn")
@export var max_health : float
@export var health: float
@export var damage : float

signal death
# Called when the node enters the scene tree for the first time.
func _ready():
	health = max_health
	var spawner = get_parent()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if health <= 0:
		handle_death()

func handle_death():
	spawn_card()
	emit_signal("death")
	print("signal")

func spawn_card():
	var new_pick_up = pick_up.instantiate()
	new_pick_up.global_position = self.global_position
	get_parent().add_child(new_pick_up)
	queue_free()

func _on_hurtbox_area_entered(area):
	health -= area.hit_damage
	print("damaged " + str(area.hit_damage))
