extends Node2D

@onready var tile_map = $TileMap

const ROOM_SIZE = Vector2(48, 27)
const HALLWAY_LENGTH = Vector2(10, 10)

const START_RECT_SIZE = Vector2(20, 20)

const EXTRA_RECT_NUM = 2
const EXTRA_RECT_SIZE_MIN = Vector2(10, 10)
const EXTRA_RECT_SIZE_MAX = Vector2(23, 13)

const MAX_ROOMS = 20

const CELL_SIZE = ROOM_SIZE + HALLWAY_LENGTH

var rooms_left = MAX_ROOMS

var rooms = Dictionary()

func _ready():
	generate_level()
	display_level()

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

func paint_rect(rect_size, rect_pos):
	rect_pos -= floor(rect_size / 2)
	for x in rect_size.x:
		for y in rect_size.y:
			var tile_coord = rect_pos + Vector2(x, y)
			tile_map.set_cell(0, tile_coord, 0, Vector2(0,0))

func get_extra_rect_size() -> Vector2:
	return Vector2(randf_range(EXTRA_RECT_SIZE_MIN.x, EXTRA_RECT_SIZE_MAX.x), randf_range(EXTRA_RECT_SIZE_MIN.y, EXTRA_RECT_SIZE_MAX.y))

func get_extra_rect_offset(rect_size) -> Vector2:
	return Vector2(randi_range(-rect_size.x/2, rect_size.x/2), randi_range(-rect_size.y/2, rect_size.y/2))
