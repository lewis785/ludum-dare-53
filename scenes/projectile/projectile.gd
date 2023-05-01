class_name Projectile extends Area2D

@export var projectile_speed: int = 1000
@export var projectile_damage: int = 10
var _asp : AudioStreamPlayer2D

var signal_bus

# Called when the node enters the scene tree for the first time.
func _ready():
	signal_bus = get_node("/root/SignalBus")
	for child in get_children():
		if child is AudioStreamPlayer2D:
			_asp = child
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	$AnimatedSprite2D.play()
	var direction = Vector2.RIGHT.rotated(rotation)
	global_position += projectile_speed * direction * delta
	pass


func destroy():
	queue_free()


func _on_body_entered(body):
	var current_enemy_name = body.name
	if current_enemy_name.contains('SupplyTruck'):
		return
		
	var enemy = body.find_child("entity")
	
	enemy.take_damage(projectile_damage)
	if !enemy.active and signal_bus:
		signal_bus.emit_signal("enemy_killed", body)
		
	$AnimatedSprite2D.hide()
	destroy()
	pass # Replace with function body.


func _on_visible_on_screen_notifier_2d_screen_exited():
	destroy()
	pass # Replace with function body.


func play_sound():
	_asp.play()
