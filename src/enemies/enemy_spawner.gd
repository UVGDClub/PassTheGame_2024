extends Node

const eater = preload("res://src/enemies/eater/eater.tscn")

var spawnable_enemies = [eater]
var enemies = 0
var enemies_to_spawn = []

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func create_enemy(enemy_type, variation):
	var enemy = spawnable_enemies[enemy_type].instantiate()
	
	enemy.setType(variation)
	enemy.death.connect(enemy_died)
	
	add_child(enemy)
	enemies_to_spawn.append(enemy)
	

func spawn_enemies(amount : int, enemy_type : int, variation : int, location : Vector2):
	print('spawning')
	for n in range(amount):
		create_enemy(enemy_type, variation)
	
	for enemy in enemies_to_spawn:
		enemies += 1
		enemy.global_position = location
	
	enemies_to_spawn.clear()


func enemy_died():
	print("recieved")
	if (enemies > 0): enemies -= 1
