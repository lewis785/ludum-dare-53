extends Node

@export var map_sectors = 9;
@export var width = 1200;
@export var height = 1200;

var sector_width = width / 3
var sector_height = height / 3
var town_turret_range = sector_width/10

# Centre sector is spawn
# Each Sector has a town
# Each town has 1-3 turrets close but not adjacent
# Maybe different types of turrets?

func populate_map():
	for sector_num in map_sectors:
		fill_sector(sector_num)

func fill_sector(sector_number):
	var x = (sector_number % 3) * sector_width
	var y = floor(sector_number / 3) * sector_height
	
	var town_x = randi_range(x + town_turret_range, (x+sector_width) - town_turret_range)
	var town_y = randi_range(y + town_turret_range, (y+sector_height) - town_turret_range)
	print("Spawn Town")
	
	for n in randi_range(1,3):
		#Spawn turret within range of town
		print("Spawn turret")
		
	
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
