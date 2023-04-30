extends CanvasLayer

@export var truck_limit = 5

var truck_status = {}
var truck_texture = load("res://assets/truck.png")
var arrow_texture = load("res://assets/arrows.png")
var sprites = []

# Called when the node enters the scene tree for the first time.
func _ready():
	init_truck_dictionary()
	display_sprites()

func init_truck_dictionary():
	for i in truck_limit:
		truck_status[i] = ""

func set_truck_status(truck_id, status):
	if truck_id < truck_limit:
		truck_status[truck_id] = status
		display_sprites()

func next_free_truck():
	for key in truck_status.keys():
		if truck_status[key] == "":
			return key
	return null

func set_truck_limit(limit):
	truck_limit = limit
	init_truck_dictionary()
	display_sprites()

func add_truck():
	truck_status[truck_limit] = ''
	truck_limit += 1
	display_sprites()

func remove_truck():
	truck_limit -= 1
	truck_status.erase(truck_limit)
	display_sprites()

func display_sprites():
	clear_sprites();
	for i in truck_limit:
		var x_pos = 32 * i
		create_truck(Vector2(x_pos, 0))
		create_status(Vector2((x_pos) + 5 , 25), truck_status[i])

func create_truck(position: Vector2):
	var sprite = Sprite2D.new()
	var rect = Rect2(0, 0, 32, 32)  # specify the rect of the single frame you want to use
	var region = AtlasTexture.new()
	sprite.position = position
	region.atlas = truck_texture
	region.region = rect
	sprite.texture = region
	sprites.append(sprite)
	$IconPosition.add_child(sprite)

func create_status(position: Vector2, type: String):
	var sprite = Sprite2D.new()
	
	var rect = Rect2(0, 0, 0, 0)
	if type == "delivering":
		rect = Rect2(0, 0, 64, 32)
	if type == "returning":
		rect = Rect2(0, 24, 64, 32)
		
	var region = AtlasTexture.new()
	sprite.position = position
	region.atlas = arrow_texture
	region.region = rect
	sprite.texture = region
	sprites.append(sprite)
	$IconPosition.add_child(sprite)

func clear_sprites():
	for sprite in sprites:
		sprite.queue_free()
	sprites = []
