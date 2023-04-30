extends Camera2D

@export var camera_speed = 30
@export var camera_zoom_speed = 0.9

var max_camera_speed

# Called when the node enters the scene tree for the first time.
func _ready():
	max_camera_speed = camera_speed
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	get_input(delta)

func get_input(delta):
	var movement = position
	if Input.is_action_pressed("camera_right"):
		movement.x += camera_speed
	if Input.is_action_pressed("camera_left"):
		movement.x -= camera_speed
	if Input.is_action_pressed("camera_up"):
		movement.y -= camera_speed
	if Input.is_action_pressed("camera_down"):
		movement.y += camera_speed
	if Input.is_action_pressed("camera_zoom_in"):
		set_zoom(get_zoom() + ((camera_zoom_speed * get_zoom())/10))
	if Input.is_action_pressed("camera_zoom_out"):
		set_zoom(get_zoom() - ((camera_zoom_speed * get_zoom())/10))
	
	camera_speed = max_camera_speed / ((get_zoom().x+1) / 2)
	position = movement
