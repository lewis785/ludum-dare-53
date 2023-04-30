extends Node2D

var paused : bool
var skipping : bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	paused = false
	get_tree().paused = false
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#var camera : Camera2D = get_parent()
	#print(camera.position)
	#position = camera.position
	pass




func _on_pause_button_button_down() -> void:
	paused = !paused
	get_tree().paused = paused
	
	var text = "pause"
	if paused:
		text += "d"
	
	$CanvasLayer/pause_button.text = text
			


func _on_skip_button_button_down() -> void:
	pass # Replace with function body.
