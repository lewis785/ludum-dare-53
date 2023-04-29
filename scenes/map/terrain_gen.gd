extends Node

@onready var tilemap := $TileMap
@export var width := 100
@export var height := 80
@export var noise_gate := 0.8

var noise_map = []

# Called when the node enters the scene tree for the first time.
func _ready():
	generate_noise_map()
	generate_map()
	fill_map()
	#recalculate_map()
	print("Map Generated")

func generate_noise_map():
	for x in width:
		noise_map.append([])
		noise_map[x] = []
		for y in height:
			var nx = x/width - 0.5
			var ny = y/height - 0.5
			noise_map[x].append([])
			noise_map[x][y] = noise(nx, ny)

func noise(nx, ny):
	return randf()

func generate_map():
	for x in width:
		for y in height:
			tilemap.set_cell(0, Vector2i(x,y),1)

func fill_map():
	var terrain_count = tilemap.tile_set.get_terrain_sets_count()
	for x in width:
		for y in height:
			var list_of_tiles = [Vector2i(x-1,y-1),Vector2i(x,y-1),Vector2i(x+1,y-1)
								,Vector2i(x-1,y),  Vector2i(x,y),  Vector2i(x+1,y)
								,Vector2i(x-1,y+1),Vector2i(x,y+1),Vector2i(x+1,y+1)]
			
			# Get random terrain
			var terrain = cell_terrain(x,y)
			
			tilemap.set_cells_terrain_connect(0, list_of_tiles, 0, terrain, true)
			#tilemap.set_cells_terrain_connect(0, [Vector2i(x,y)], 0, terrain, true) #Why does this not work???
			
func recalculate_map():
	for n in (width*height):
		var randx = randi_range(0, width)
		var randy = randi_range(0, height)
		var terrain = cell_terrain(randx,randy)
		tilemap.set_cells_terrain_connect(0, [Vector2i(randx, randy)], 0, terrain, true)
	

func cell_terrain(x,y):
	if randf_range(0,2) > cell_noise(x,y):
		return 1
	return 0

func cell_noise(x,y):
	var noise = 0
	# Check if neighbour cells are water
	if x > 1:
		noise += noise_map[x-1][y]
	if x < width-1:
		noise += noise_map[x+1][y]
	if y < 1:
		noise += noise_map[x][y-1]
	if y < height-1:
		noise += noise_map[x][y+1]
	return noise
