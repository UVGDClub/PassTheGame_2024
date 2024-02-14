extends Node2D

@onready var tile_map = $TileMap
@onready var camera = $Camera2D
@onready var player = $Player

@onready var card_pack = load("res://src/cards/card_pack/card_pack_pickup.tscn")

const ROOM_SIZE = Vector2(30, 16)
const HALLWAY_LENGTH = Vector2(20, 15)

const START_RECT_SIZE = Vector2(20, 17)

const EXTRA_RECT_NUM = 10
const EXTRA_RECT_SIZE_MIN = Vector2(5, 5)
const EXTRA_RECT_SIZE_MAX = Vector2(19, 8)

const MAX_ROOMS = 20

const CELL_SIZE = ROOM_SIZE + HALLWAY_LENGTH

const FLOOR_TILE_SET_ATLAS_COORDS = Vector2i(3,3)
const WALL_TILE_SET_ATLAS_COORDS = Vector2i(12,2)
const VOID_TILE_SET_ATLAS_COORDS = Vector2i(16,3)

const PACK_CHANCE_temp = 0.5

var rooms_left = MAX_ROOMS

var top_left = Vector2.ZERO
var bot_right = Vector2.ZERO

var rooms = Dictionary()
var walls = []
var camera_tween : Tween

func _ready():
	generate_level()
	display_level()
	add_packs_to_rooms()

func _process(delta):
	update_camera()

var currentRoom : Vector2

func update_camera():
	# Beautiful tweening system is courtesy of Inbesticorp™️©️®️ 🔥🔥🔥
	for room in rooms.values():
		if is_player_in_room(room):
			if currentRoom == room.glo_pos: return
			currentRoom = room.glo_pos
			var camera_tween = create_tween()
			camera_tween.set_ease(2).tween_property(camera, "position", room.glo_pos, 0.5)
			return
	currentRoom = Vector2(69420, 69420)
	var camera_tween = create_tween()
	camera_tween.set_ease(2).tween_property(camera, "position", player.global_position, 0.5)
	
func is_player_in_room(room):
	return (
		abs(player.global_position.x - room.glo_pos.x) < ROOM_SIZE.x * 20 / 2 and
		abs(player.global_position.y - room.glo_pos.y) < ROOM_SIZE.y * 20 / 2
	)

func generate_level():
	rooms[Vector2.ZERO] = create_room(Vector2.ZERO)
	var leaf_rooms = [rooms[Vector2.ZERO]]
	while rooms_left:
		var next_leaf_rooms = []
		for room in leaf_rooms:
			next_leaf_rooms += add_connections(room)
		if not next_leaf_rooms:
			break
		leaf_rooms = next_leaf_rooms

func add_connections(room) -> Array:
	var con_min = 1 if rooms_left <= MAX_ROOMS/2 else 3
	var connect_num = min(randi_range(con_min, 4), rooms_left)
	var vects = [Vector2.RIGHT, Vector2.LEFT, Vector2.UP, Vector2.DOWN]
	var new_leaf_rooms = []
	if room.original_connection != Vector2.ZERO:
		vects.erase(room.original_connection)
		connect_num -= 1
	
	for i in range(connect_num):
		var dir = vects.pick_random()
		vects.erase(dir)
		var new_room_pos = room.grid_position + dir
		if new_room_pos in rooms:
			connect_rooms(room, rooms[new_room_pos])
		else:
			var new_room = create_room(new_room_pos)
			new_room.original_connection = room.grid_position - new_room_pos
			connect_rooms(room, new_room)
			rooms[new_room_pos] = new_room
			new_leaf_rooms.append(new_room)
			rooms_left -= 1
	
	return new_leaf_rooms

func create_room(grid_pos) -> Room:
	var new_room = Room.new()
	new_room.grid_position = grid_pos
	new_room.tile_pos = grid_pos * CELL_SIZE
	new_room.glo_pos = grid_pos * CELL_SIZE * 16
	return new_room

func connect_rooms(room1, room2):
	var dir = room2.grid_position - room1.grid_position
	room1.connections.append(dir)
	room2.connections.append(dir * -1)
	var offset = get_connection_offset("x" if dir.x == 0 else "y")
	room1.connection_offsets[dir] = offset
	room2.connection_offsets[dir * -1] = offset

func get_connection_offset(axis) -> int:
	var size = START_RECT_SIZE[axis] - 2
	return randi_range(0, size) - size/2

func display_level():
	for room in rooms.values():
		paint_rect(START_RECT_SIZE, room.tile_pos)
		for i in range(EXTRA_RECT_NUM):
			var rect_size = get_extra_rect_size()
			var rect_pos_offset = get_extra_rect_offset(rect_size)
			paint_rect(rect_size, room.tile_pos + rect_pos_offset)
		for con in room.connections:
			var rect_size
			var rect_pos_offset
			if con.x != 0:
				rect_size = Vector2((ROOM_SIZE.x + HALLWAY_LENGTH.x)/2, 4)
				rect_pos_offset = Vector2((ROOM_SIZE.x + HALLWAY_LENGTH.x)/4 * con.x, room.connection_offsets[con])
			else:
				rect_size = Vector2(4, (ROOM_SIZE.y + HALLWAY_LENGTH.y)/2)
				rect_pos_offset = Vector2(room.connection_offsets[con], (ROOM_SIZE.x + HALLWAY_LENGTH.x)/4 * con.y)
			paint_rect(rect_size, room.tile_pos + rect_pos_offset)
	
	fill_map()

func paint_rect(rect_size, rect_pos):
	rect_pos -= floor(rect_size / 2)
	
	bot_right.x = max(bot_right.x, rect_pos.x + rect_size.x)
	bot_right.y = max(bot_right.y, rect_pos.y + rect_size.y)
	top_left.x = min(top_left.x, rect_pos.x)
	top_left.y = min(top_left.y, rect_pos.y)
	
	for x in rect_size.x:
		for y in rect_size.y:
			var tile_coord = rect_pos + Vector2(x, y)
			tile_map.set_cell(0, tile_coord, 1, Vector2(1 ,1))

func fill_map():
	bot_right += ROOM_SIZE
	top_left -= ROOM_SIZE
	for x in range(round(bot_right.x - top_left.x)):
		for y in range(round(bot_right.x - top_left.x)):
			var tile_coord = top_left + Vector2(x, y)
			if tile_map.get_cell_atlas_coords(0, tile_coord) == Vector2i(-1, -1):
				if adj_to_floor(tile_coord):
					tile_map.set_cell(0, tile_coord, 0, Vector2(0, 0))
					walls.push_back(tile_coord)
				else: tile_map.set_cell(0, tile_coord, 0, VOID_TILE_SET_ATLAS_COORDS)
	assignWalls()

func assignWalls():
	# Ugly code incoming
	for wall in walls:
		var number = 0;
		if tile_map.get_cell_atlas_coords(0, Vector2(wall.x, wall.y - 1)) == VOID_TILE_SET_ATLAS_COORDS:
			number += 1
		if tile_map.get_cell_atlas_coords(0, Vector2(wall.x + 1, wall.y)) == VOID_TILE_SET_ATLAS_COORDS:
			number += 2
		if tile_map.get_cell_atlas_coords(0, Vector2(wall.x, wall.y + 1)) == VOID_TILE_SET_ATLAS_COORDS:
			number += 4
		if tile_map.get_cell_atlas_coords(0, Vector2(wall.x - 1, wall.y)) == VOID_TILE_SET_ATLAS_COORDS:
			number += 8
		
		match number:
			1:
				tile_map.set_cell(0, wall, 1, Vector2(1, 0))
			2:
				tile_map.set_cell(0, wall, 1, Vector2(4, 1))
			3:
				tile_map.set_cell(0, wall, 1, Vector2(4, 0))
			4:
				tile_map.set_cell(0, wall, 1, Vector2(1, 4))
			6:
				tile_map.set_cell(0, wall, 1, Vector2(4, 4))
			8:
				tile_map.set_cell(0, wall, 1, Vector2(0, 1))
			9:
				tile_map.set_cell(0, wall, 1, Vector2(0, 0))
			12:
				tile_map.set_cell(0, wall, 1, Vector2(0, 4))
			0:
				if tile_map.get_cell_atlas_coords(0, Vector2(wall.x - 1, wall.y - 1)) == Vector2i(-1, -1):
					tile_map.set_cell(0, wall, 4, Vector2(2, 2))
				elif tile_map.get_cell_atlas_coords(0, Vector2(wall.x + 1, wall.y + 1)) == Vector2i(-1, -1):
					tile_map.set_cell(0, wall, 4, Vector2(0, 0))
				elif tile_map.get_cell_atlas_coords(0, Vector2(wall.x - 1, wall.y + 1)) == Vector2i(-1, -1):
					tile_map.set_cell(0, wall, 4, Vector2(2, 0))
				elif tile_map.get_cell_atlas_coords(0, Vector2(wall.x + 1, wall.y - 1)) == Vector2i(-1, -1):
					tile_map.set_cell(0, wall, 4, Vector2(0, 2))
				else: tile_map.set_cell(0, wall, 1, Vector2(1, 1))

func add_packs_to_rooms() -> void:
	var rng: RandomNumberGenerator = RandomNumberGenerator.new()
	for r in rooms.values():
		# so that people aren't confused when they open the game
		if r.grid_position == Vector2.ZERO: continue
		
		if (rng.randf() < PACK_CHANCE_temp):
			var new_card_pack = card_pack.instantiate()
			new_card_pack.global_position = r.glo_pos
			add_child(new_card_pack)

func adj_to_floor(coord) -> bool:
	var dirs = [Vector2(1,1),Vector2(0,1),Vector2(1,0),Vector2(-1,0),Vector2(0,-1),Vector2(-1,-1),Vector2(-1,1),Vector2(1,-1)]
	for dir in dirs:
		if tile_map.get_cell_atlas_coords(0, coord + dir) == Vector2i(1, 1):
			return true
	return false

func get_extra_rect_size() -> Vector2:
	return Vector2(randf_range(EXTRA_RECT_SIZE_MIN.x, EXTRA_RECT_SIZE_MAX.x), randf_range(EXTRA_RECT_SIZE_MIN.y, EXTRA_RECT_SIZE_MAX.y))

func get_extra_rect_offset(rect_size) -> Vector2:
	return Vector2(randi_range(-rect_size.x/2, rect_size.x/2), randi_range(-rect_size.y/2, rect_size.y/2))
