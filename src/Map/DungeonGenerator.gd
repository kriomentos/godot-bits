class_name DungeonGenerator
extends Node

@export_category("Map Dimensions")
@export var map_width: int = 80
@export var map_height: int = 50

var iterations = 25000
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
	
	for y in range(map_height / 2 - 1 , map_height / 2 + 2):
		for x in range(1, map_width - 1):
			_carve_tile(dungeon, x, y)
	
	dig_caves(dungeon)
	
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
		var x = floor(randf_range(1, map_width - 1))
		var y = floor(randf_range(1, map_height - 1))
		
		if check_nearby(dungeon, x, y) > neighbors:
			_uncarve_tile(dungeon, x, y)
		elif check_nearby(dungeon, x, y) < neighbors:
			_carve_tile(dungeon, x, y)
	
func check_nearby(dungeon: MapData, x: int, y: int):
	var count = 0
	if not dungeon.get_tile(Vector2i(x, y-1)).is_walkable(): count += 1
	if not dungeon.get_tile(Vector2i(x, y+1)).is_walkable(): count += 1
	if not dungeon.get_tile(Vector2i(x-1, y)).is_walkable(): count += 1
	if not dungeon.get_tile(Vector2i(x+1, y)).is_walkable(): count += 1
	if not dungeon.get_tile(Vector2i(x+1, y+1)).is_walkable(): count += 1
	if not dungeon.get_tile(Vector2i(x+1, y-1)).is_walkable(): count += 1
	if not dungeon.get_tile(Vector2i(x-1, y+1)).is_walkable(): count += 1
	if not dungeon.get_tile(Vector2i(x-1, y-1)).is_walkable(): count += 1
	return count

func get_all_caves(dungeon: MapData):
	var caves = []
	
	for y in map_height:
		for x in map_width:
			if dungeon.get_tile(Vector2i(x, y)) == dungeon.tile_types.floor:
				flood_fill(dungeon, x, y)
				
func flood_fill(dungeon: MapData, tile_x: int, tile_y: int):
	var cave = []
	var to_fill = [Vector2(tile_x, tile_y)]
	while to_fill:
		var tile = to_fill.pop_back()
		
		if !cave.has(tile):
			cave.append(tile)
			
