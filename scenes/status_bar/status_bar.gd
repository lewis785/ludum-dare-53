extends Control

@export var label = "Status"
@export var percentage = 0
@export var colour: Color
@export var texture: Texture2D

func set_texture():
	var new_stylebox_normal = $ProgressBar.get_theme_stylebox("fill").duplicate()
	new_stylebox_normal.texture = texture
	$ProgressBar.add_theme_stylebox_override("fill", new_stylebox_normal)

func set_percentage(value: int):
	percentage = value
	update_process_bar()

func update_process_bar():
	$ProgressBar.value = percentage
	

func update_colour():
	var tmp_colour = self.get_modulate()
	tmp_colour.r = colour.r *  255.0
	tmp_colour.g = colour.g * 255.0
	tmp_colour.b = colour.b * 255.0
	self.set_modulate(colour)
	
func _ready():
	update_colour()
	update_process_bar()
	set_texture()

