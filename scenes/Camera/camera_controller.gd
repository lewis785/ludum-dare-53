extends Camera2D

@export var camera_speed = 20

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
	
	position = movement
	print(movement)
