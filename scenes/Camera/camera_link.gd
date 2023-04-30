const Camera = preload("res://scenes/Camera/camera_controller.gd")

var camera : Camera

func link_camera(tree):
	camera = tree.get_first_node_in_group("camera")
	
func set_limits(upper_x, upper_y, lower_x, lower_y):
	if camera.limit_camera:
		camera.set_limits(upper_x, upper_y, lower_x, lower_y)
