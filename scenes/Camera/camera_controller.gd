extends Camera2D
class_name Camera

@export var camera_speed = 30
@export var camera_zoom_speed = 0.9
@export var limit_camera = true

var max_camera_speed = camera_speed

# Called when the node enters the scene tree for the first time.
func _ready():
	if camera_speed <= 0:
		camera_speed = 30
	max_camera_speed = camera_speed

	if camera_zoom_speed <= 0:
		camera_zoom_speed = 1


func set_limits(upper_x, upper_y, lower_x, lower_y):
	self.set_limit(0,upper_x)
	self.set_limit(1,upper_y)
	self.set_limit(2,lower_x)
	self.set_limit(3,lower_y)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	get_input(delta)

func get_input(delta):
	var movement = position
	var zoom_change = false
	if Input.is_action_pressed("camera_right"):
		movement.x += camera_speed
	if Input.is_action_pressed("camera_left"):
		movement.x -= camera_speed
	if Input.is_action_pressed("camera_up"):
		movement.y -= camera_speed
	if Input.is_action_pressed("camera_down"):
		movement.y += camera_speed
	if Input.is_action_pressed("camera_zoom_in") or Input.is_action_just_released("camera_zoom_in"):
		zoom_change = true
		set_zoom(get_zoom() + ((camera_zoom_speed * get_zoom())/10))
	if Input.is_action_pressed("camera_zoom_out") or Input.is_action_just_released("camera_zoom_out"):
		zoom_change = true
		set_zoom(get_zoom() - ((camera_zoom_speed * get_zoom())/10))
	if zoom_change:
		camera_speed = max_camera_speed / ((get_zoom().x+1) / 2)
	position = movement
