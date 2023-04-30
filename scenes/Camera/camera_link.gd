const Camera = preload("res://scenes/Camera/camera_controller.gd")

var camera : Camera

func link_camera(tree):
	print(tree)
	camera = tree.get_first_node_in_group("camera")
	#camera = tree.current_scene.get_node("$Camera")
	
func set_limits(upper_x, upper_y, lower_x, lower_y):
	camera.set_limits(upper_x, upper_y, lower_x, lower_y)
