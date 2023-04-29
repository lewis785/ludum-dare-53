class_name Projectile extends Area2D

@export var projectile_speed: int = 100


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var direction = Vector2.RIGHT.rotated(rotation)
	global_position += projectile_speed * direction * delta
	pass

func destroy():
	queue_free()


func _on_body_entered(body):
	SignalBus.emit_signal("do_damage", body)
	destroy()
	pass # Replace with function body.


func _on_visible_on_screen_notifier_2d_screen_exited():
	destroy()
	pass # Replace with function body.


