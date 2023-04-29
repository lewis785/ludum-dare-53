extends Node

const TG = preload("res://scenes/map/terrain_gen.gd")
const MP = preload("res://scenes/map/map_populate.gd")

@onready var tilemap := $TileMap
@export var width := 900
@export var height := 900
@export var map_sectors = 9;
@export var noise_gate := 0.4

# Called when the node enters the scene tree for the first time.
func _ready():
	var terrain_gen = TG.new(tilemap, width, height, noise_gate)
	#var map_populate = MP.new(width, height, map_sectors)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
