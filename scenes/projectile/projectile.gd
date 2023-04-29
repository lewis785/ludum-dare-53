class_name Projectile extends Area2D

@export var projectile_speed: int = 1000
var _animated_sprite

var signal_bus

# Called when the node enters the scene tree for the first time.
func _ready():
	signal_bus = get_node("/root/SignalBus")
	_animated_sprite = $AnimatedSprite2D
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


