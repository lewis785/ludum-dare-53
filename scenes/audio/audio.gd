extends Node2D
class_name AudioManager

var asp : AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	asp = $AudioStreamPlayer
	pass
	
func get_asp():
	asp = $AudioStreamPlayer

func play_audio():
	asp.play()

func stop_audio():
	asp.stop()

func set_volume(volume : float):
	asp.set_volume_db(volume)

func adjust_pitch(pitch):
	asp.set_pitch_scale(pitch)
