extends Node2D

@export var score_label : Label
@export var num_only : bool = true

var score = 0

func _ready():
	var signal_bus = get_node("/root/SignalBus")
	signal_bus.connect('score_update', update_score)

func update_score(value: int):
	score += value
	update_label();
	
func update_label():
	if num_only:
		score_label.text = str(score)
	else:
		score_label.text = "Score: " + str(score)
	
