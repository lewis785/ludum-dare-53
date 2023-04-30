extends Node2D
class_name AudioManager

var asp : AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	#asp = get_tree().get_first_node_in_group("AudioPlayer")
	pass
	#play_audio()
	
func get_asp():
	asp = $AudioStreamPlayer

func play_audio():
	asp.play()

func adjust_pitch(pitch):
	if !asp:
		get_asp()
	asp.set_pitch_scale(pitch)

func stop_audio():
	if !asp:
		get_asp()
	asp.stop()
