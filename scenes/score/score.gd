extends Node2D

var score = 0

func _ready():
	var signal_bus = get_node("/root/SignalBus")
	signal_bus.connect('score_update', update_score)

func update_score(value: int):
	score += value
	update_label();
	
func update_label():
	$CanvasLayer/ScoreLabel.text = str(score)
	
