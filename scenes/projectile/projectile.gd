class_name Projectile extends Area2D

@export var projectile_speed: int = 1000
var _animated_sprite
var _asp : AudioStreamPlayer2D

var signal_bus

# Called when the node enters the scene tree for the first time.
func _ready():
	signal_bus = get_node("/root/SignalBus")
	_animated_sprite = $AnimatedSprite2D
	#var path = self.get_path() + NodePath("/AudioStreamPlayer2D")
	for child in get_children():
		if child is AudioStreamPlayer2D:
			_asp = child
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	_animated_sprite.play()
	var direction = Vector2.RIGHT.rotated(rotation)
	global_position += projectile_speed * direction * delta
	pass


func destroy():
	queue_free()


func _on_body_entered(body):
	signal_bus.emit_signal("do_damage_to_enemy", body)
	destroy()
	pass # Replace with function body.


func _on_visible_on_screen_notifier_2d_screen_exited():
	destroy()
	pass # Replace with function body.


func play_sound():
	_asp.play()
