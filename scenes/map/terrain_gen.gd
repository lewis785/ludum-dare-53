extends Node

@onready var tilemap := $TileMap
@export var width := 100
@export var height := 80

# Called when the node enters the scene tree for the first time.
func _ready():
	generate_map()
	fill_map()
	print("done")

func generate_map():
	for x in width:
		for y in height:
			tilemap.set_cell(0, Vector2i(x,y),0)

func fill_map():
	for x in width:
		for y in height:
			var list_of_tiles = [Vector2i(x-1,y-1),Vector2i(x,y-1),Vector2i(x+1,y-1)
								,Vector2i(x-1,y),  Vector2i(x,y),  Vector2i(x+1,y)
								,Vector2i(x-1,y+1),Vector2i(x,y+1),Vector2i(x+1,y+1)]
			
			# Get random terrain
			var terrain = randi_range(0,tilemap.tile_set.get_terrain_sets_count())
			
			tilemap.set_cells_terrain_connect(0, list_of_tiles, 0, terrain, true)
