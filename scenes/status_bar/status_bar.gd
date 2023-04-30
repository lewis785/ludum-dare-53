extends Control

@export var label = "Status"
@export var percentage = 0
@export var colour: Color

func set_label(value: String):
	$Label.text = value
	update_label();

func set_percentage(value: int):
	percentage = value
	update_process_bar()

func update_process_bar():
	$ProgressBar.value = percentage
	
func update_label():
	$Label.text = label

func update_colour():
	var tmp_colour = self.get_modulate()
	tmp_colour.r = colour.r *  255.0
	tmp_colour.g = colour.g * 255.0
	tmp_colour.b = colour.b * 255.0
	self.set_modulate(colour)
	
func _ready():
	update_colour()
	update_label()
	update_process_bar()

