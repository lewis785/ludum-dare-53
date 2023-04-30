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
	
	generate_map()
	print("Map Generated")

func generate_map():
	# Fill map with default cells
	for x in width:
		for y in height:
			tilemap.set_cell(0, Vector2i(x,y),0, Vector2i(1,1))
	
	# Set terrain to random terrain type
	var terrain_count = tilemap.tile_set.get_terrain_sets_count()
	var terrain = randi_range(0,terrain_count-1)
	tilemap.set_cells_terrain_connect(0, tilemap.get_used_cells(0), 0, terrain, true)
