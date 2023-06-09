extends Node

const TG = preload("res://scenes/map/terrain_gen.gd")
const MP = preload("res://scenes/map/map_populate.gd")
const CL = preload("res://scenes/Camera/camera_link.gd")

@onready var tilemap := $TileMap
@export var width := 900
@export var height := 900
@export var map_rows = 3;
@export var map_columns = 3;
@export var noise_gate := 0.4

# Called when the node enters the scene tree for the first time.
func _ready():
	TG.new(tilemap, width, height, noise_gate)
	var mp = MP.new(tilemap, get_tree(), width, height, map_rows, map_columns)
	var map_size = tilemap.get_used_rect().size
	var tile_size = tilemap.cell_quadrant_size
	var world_size = map_size * tile_size
	
	var cl = CL.new()
	cl.link_camera(get_tree())
	cl.set_limits(0,0,world_size.x,world_size.y)
	cl.set_to_point(mp.depot_position)

