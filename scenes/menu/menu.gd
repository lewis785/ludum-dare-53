extends Node2D

var paused : bool
var skipping : bool

var game_scene = preload("res://scenes/game/game.tscn")
var audio = preload("res://scenes/audio/audio.tscn")
#const audio_manager = preload("res://scenes/audio/audio.gd")

var am : AudioManager

# Called when the node enters the scene tree for the first time.
func _ready() -> void:	
	skipping = false
	
	pause()
	
	am = audio.instantiate()
	get_tree().current_scene.add_child.call_deferred(am)
	am.get_asp()
	
	$CanvasLayer/controls.hide()
	$CanvasLayer/end.hide()
	$CanvasLayer/start.show()
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if paused:
		return
		
	if is_game_over():
		am.stop_audio()
		pause()
		$CanvasLayer/controls.hide()
		$CanvasLayer/end.show()


func is_game_over() -> bool:
	var entities = get_tree().get_nodes_in_group("ally")
	
	for entity in entities:
		if entity.alive and entity.active:
			
			return false

	return true
	
func _on_pause_button_button_down() -> void:
	if paused:
		play()
	else:
		pause()
	


func play() -> void:
	paused = false
	get_tree().paused = false
	
	$CanvasLayer/controls/skip_button.show()
	$CanvasLayer/controls/pause_button.text = "pause"

func pause() -> void:
	paused = true
	get_tree().paused = true
	
	$CanvasLayer/controls/pause_button.text = "paused"
			


func _on_skip_button_button_down() -> void:
	if skipping:
		normal_speed()
	else:
		fast_forward()
	
func fast_forward() -> void:
	skipping = true
	var text = "slow"
	Engine.time_scale = 10
	
	$CanvasLayer/controls/skip_button.text = text
	
func normal_speed() -> void:
	skipping = false
	var text = "skip"
	Engine.time_scale = 1
	
	$CanvasLayer/controls/skip_button.text = text


func _on_start_button_button_down() -> void:
	start_game()

func start_game() -> void:
	$CanvasLayer/start.hide()
	$CanvasLayer/end.hide()
	
	normal_speed()
	play()
	am.play_audio()
	
	$CanvasLayer/controls.show()


func _on_restart_button_button_up() -> void:
	var game_nodes = get_tree().get_nodes_in_group("game")
	
	for game in game_nodes:		
		game.queue_free()
	
	var main_scene = get_tree().get_first_node_in_group("main")
	
	var new_game = game_scene.instantiate()
	main_scene.add_child(new_game)
	
	start_game()
