var tilemap
var width
var height
var noise_gate

var noise_map = []

func _init(local_tilemap, local_width, local_height, local_noise_gate):
	tilemap = local_tilemap
	width = local_width
	height = local_height
	noise_gate = local_noise_gate
	
	generate_noise_map()
	generate_map()
	#fill_map()
	#recalculate_map()
	print("Map Generated")

func generate_noise_map():
	for x in width:
		noise_map.append([])
		noise_map[x] = []
		for y in height:
			#var nx = x/width - 0.5
			#var ny = y/height - 0.5
			noise_map[x].append([])
			noise_map[x][y] = noise(x, y)

func noise(nx, ny):
	#return randf() * (1 / abs(sin(nx) * sin(ny)))
	return abs(cos(nx) - sin(ny))

func generate_map():
	for x in width:
		for y in height:
			#tilemap.set_cell(0, Vector2i(x,y),0)
			tilemap.set_cell(0, Vector2i(x,y),0, Vector2i(7,6))

func fill_map():
	var terrain_count = tilemap.tile_set.get_terrain_sets_count()
	for x in width:
		#print("X:", x)
		for y in height:
			#print("Y:", y)
			var list_of_tiles = [Vector2i(x-1,y-1),Vector2i(x,y-1),Vector2i(x+1,y-1)
								,Vector2i(x-1,y),  Vector2i(x,y),  Vector2i(x+1,y)
								,Vector2i(x-1,y+1),Vector2i(x,y+1),Vector2i(x+1,y+1)]
			
			# Get random terrain
			var terrain = cell_terrain(x,y)
			
			#tilemap.set_cells_terrain_connect(0, list_of_tiles, 0, terrain, true)
			#tilemap.set_cells_terrain_connect(0, [Vector2i(x,y)], 0, terrain, true) #Why does this not work???
			
			if terrain == 0:
				tilemap.set_cell(0, Vector2i(x,y),0, Vector2i(7,6))
			else:
				tilemap.set_cell(0, Vector2i(x,y),0, Vector2i(4,7))

func cell_terrain(x,y):
	#if randf_range(0,1) > cell_noise(x,y):
	#	return 1
	#return 0
	#var noise = cell_noise(x,y)
	var noise = randf() * cell_noise(x,y)
	print(noise)
	if noise > noise_gate:
		return 1
	return 0

func cell_noise(x,y):
	var noise = noise_map[x][y]
	# Check if neighbour cells are water
	if x > 1:
		noise += noise_map[x-1][y]
	if x < width-1:
		noise += noise_map[x+1][y]
	if y < 1:
		noise += noise_map[x][y-1]
	if y < height-1:
		noise += noise_map[x][y+1]
	noise = noise/5
	return noise

func recalculate_map():
	for n in (width*height):
		var randx = randi_range(0, width-1)
		var randy = randi_range(0, height-1)
		var terrain = cell_terrain(randx,randy)
		tilemap.set_cells_terrain_connect(0, [Vector2i(randx, randy)], 1, terrain, true)
