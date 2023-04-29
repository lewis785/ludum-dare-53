var width = 900;
var height = 900;
var map_sectors;

var sector_width
var sector_height
var town_turret_range

var tilemap
var tree
var structure: PackedScene = preload("res://scenes/structure/structure.tscn")

# Centre sector is spawn
# Each Sector has a town
# Each town has 1-3 turrets close but not adjacent
# Maybe different types of turrets?



func _init(local_tilemap, local_tree, local_width, local_height, local_map_sectors=9):
	tilemap = local_tilemap
	tree = local_tree

	width = local_width
	height = local_height
	map_sectors = local_map_sectors
	
	sector_width = width / 3
	sector_height = height / 3
	town_turret_range = sector_width/10
	
	populate_map()

func populate_map():
	#print("TileMap Pos X:", tilemap.position.x, " Y:", tilemap.position.y)
	#spawn_structure(5, 5)
	for sector_num in map_sectors:
		fill_sector(sector_num)
	
	#spawn_structure(2, 2)

func fill_sector(sector_number):
	var x = (sector_number % 3) * sector_width
	var y = floor(sector_number / 3) * sector_height
	
	var town_x = randi_range(x + town_turret_range, (x+sector_width) - town_turret_range)
	var town_y = randi_range(y + town_turret_range, (y+sector_height) - town_turret_range)
	spawn_structure(town_x, town_y)
	
	for n in randi_range(1,3):
		#Spawn turret within range of town
		#print("Spawn turret")
		pass
	
func fill_spawn_sector():
	pass

func spawn_structure(x,y):
	if structure:
		var local_position =  tilemap.map_to_local(Vector2i(x,y))
		var instanced_structure = structure.instantiate()
		tree.current_scene.add_child.call_deferred(instanced_structure)
		instanced_structure.global_position = tilemap.to_global(local_position)
		print("Town Grid Coord at X:", x, "  Y:", y)
		print("Spawned Town at X:", instanced_structure.global_position.x, "  Y:", instanced_structure.global_position.y)
