class_name DungeonGenerator
extends Node

@export_category("Map Dimensions")
@export var map_width: int = 80
@export var map_height: int = 50

var iterations = 20000
var neighbors = 4
var _rng = RandomNumberGenerator.new()

func _ready() -> void:
	_rng.randomize()

func generate_dungeon() -> MapData:
	var dungeon := MapData.new(map_width, map_height)
	
	for y in range(1, map_height - 1):
		for x in range(1, map_width - 1):
			if Chance.new().chance(48):
				_carve_tile(dungeon, x, y)
	
	var testx = randf_range(map_height, map_width - 1)
	var testy = randf_range(map_height, map_width - 1)
	#dig_caves(dungeon)
	
	return dungeon

func _carve_tile(dungeon: MapData, x: int, y: int) -> void:
	var tile_position = Vector2i(x, y)
	var tile: Tile = dungeon.get_tile(tile_position)
	tile.set_tile_type(dungeon.tile_types.floor)
	
func _uncarve_tile(dungeon: MapData, x: int, y: int) -> void:
	var tile_position = Vector2i(x, y)
	var tile: Tile = dungeon.get_tile(tile_position)
	tile.set_tile_type(dungeon.tile_types.wall)

func dig_caves(dungeon: MapData):
	for i in range(iterations):
		var x = floor(randf_range(1, map_height - 1))
		var y = floor(randf_range(1, map_width - 1))
		var test = check_nearby(dungeon, x, y)
		
		if test > neighbors:
			_carve_tile(dungeon, x, y)
		#elif test < neighbors:
			#_carve_tile(dungeon, x, y)
	
func check_nearby(dungeon, x, y):
	var count = 0
	if dungeon.get_tile(Vector2i(x, y-1)):  count += 1
	if dungeon.get_tile(Vector2i(x, y+1)):  count += 1
	if dungeon.get_tile(Vector2i(x-1, y)):  count += 1
	if dungeon.get_tile(Vector2i(x+1, y)):  count += 1
	if dungeon.get_tile(Vector2i(x+1, y+1)):  count += 1
	if dungeon.get_tile(Vector2i(x+1, y-1)):  count += 1
	if dungeon.get_tile(Vector2i(x-1, y+1)):  count += 1
	if dungeon.get_tile(Vector2i(x-1, y-1)):  count += 1
	return count
