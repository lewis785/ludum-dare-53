extends Node

static func init_supply_bar(status_bar: ProgressBar, status_label: Label, value: int):
	status_bar.value = value
	status_label.text = "Supply"
	var supply_colour = status_bar.get_modulate()
	supply_colour.r = 255.0
	supply_colour.g = 205.0
	supply_colour.b = 0.1
	status_bar.set_modulate(supply_colour)

static func init_health_bar(status_bar: ProgressBar, status_label: Label, value: int):
	status_bar.value = value
	status_label.text = "Health"
	var health_colour = status_bar.get_modulate()
	health_colour.r = 255.0
	health_colour.g = 0.0
	health_colour.b = 0.0
	status_bar.set_modulate(health_colour)

static func update_status_bar(status_bar: ProgressBar, value: int):
	status_bar.value = value
