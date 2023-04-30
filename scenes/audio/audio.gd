extends Node2D

var asp : AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	asp = $AudioStreamPlayer

func play_audio():
	pass
	#asp.play()

func stop_audio():
	pass
	#asp.stop()
