var width = 900
var height = 900
var map_rows
var map_columns
var map_sectors

var sector_width
var sector_height
var town_turret_range

var tilemap
var tree
var structure: PackedScene = preload("res://scenes/structure/structure.tscn")
var depot: PackedScene = preload("res://scenes/supply_depot/supply_depot.tscn")

# Centre sector is spawn
# Each Sector has a town
# Each town has 1-3 turrets close but not adjacent
# Maybe different types of turrets?



func _init(local_tilemap, local_tree, local_width, local_height, local_map_rows, local_map_columns):
	tilemap = local_tilemap
	tree = local_tree

	width = local_width
	height = local_height
	map_rows = local_map_rows
	map_columns = local_map_columns
	map_sectors = map_rows * map_columns
	
	sector_width = width / map_columns
	sector_height = height / map_rows
	town_turret_range = sector_width/4
	
	populate_map()

func populate_map():
	for sector_num in map_sectors:
		fill_sector(sector_num)

func fill_sector(sector_number):
	var sector_x = (sector_number % map_columns) * sector_width
	var sector_y = floor(sector_number / map_columns) * sector_height
	
	var town_x = randi_range(sector_x + town_turret_range, (sector_x+sector_width) - town_turret_range)
	var town_y = randi_range(sector_y + town_turret_range, (sector_y+sector_height) - town_turret_range)
	spawn_structure(town_x, town_y)
	
	for n in randi_range(1,3):
		#Spawn turret within range of town
		var offset = randi_range(town_turret_range/3, town_turret_range)
		var turret_x
		var turret_y
		if randf() > 0.5:
			turret_x = town_x + offset
		else:
			turret_x = town_x - offset
		if randf() > 0.5:
			turret_y = town_y + offset
		else:
			turret_y = town_y - offset
		spawn_structure(turret_x,turret_y,true)
		#print("Spawn turret")
	if sector_number == ceil(map_sectors / 2):
		var offset = randi_range(town_turret_range/10, town_turret_range)
		var depot_x
		var depot_y
		if randf() > 0.5:
			depot_x = town_x + offset
		else:
			depot_x = town_x - offset
		if randf() > 0.5:
			depot_y = town_y + offset
		else:
			depot_y = town_y - offset
		spawn_depot(depot_x,depot_y)
	
func spawn_depot(x,y):
	if depot:
		var local_position =  tilemap.map_to_local(Vector2i(x,y))
		var instanced_depot = depot.instantiate()
		tree.current_scene.add_child.call_deferred(instanced_depot)
		instanced_depot.global_position = tilemap.to_global(local_position)

func spawn_structure(x,y, is_tower=false):
	if structure:
		var local_position =  tilemap.map_to_local(Vector2i(x,y))
		var instanced_structure = structure.instantiate()
		tree.current_scene.add_child.call_deferred(instanced_structure)
		instanced_structure.global_position = tilemap.to_global(local_position)
		if is_tower:
			instanced_structure.set_tower()
