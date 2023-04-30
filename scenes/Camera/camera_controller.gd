extends Camera2D

@export var camera_speed = 20
@export var camera_zoom_speed = 1

# Called when the node enters the scene tree for the first time.
func _ready():
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
		print("camera_zoom_in")
		set_zoom(get_zoom() - Vector2(camera_zoom_speed, camera_zoom_speed))
	if Input.is_action_pressed("camera_zoom_out"):
		print("camera_zoom_out")
		set_zoom(get_zoom() + Vector2(camera_zoom_speed, camera_zoom_speed))
	
	position = movement
