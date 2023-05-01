extends Node2D

@export var level : int = 1
@export var enemy_scene : PackedScene
@export var scale_factor : int = 1

var score : int
var base_wait_time : float
var enemy_level: float = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	new_game()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func new_game():
	score = 0
		
	var child =  self.get_parent().find_child("*map*")
	
	if child:
		var pos : Vector2i = Vector2i(0, 0)
		var map = %map
		
		var width = map.width
		var height = map.height
	
		var size = Vector2i(width*scale_factor, height*scale_factor)
	
		var c = Curve2D.new()
			
		c.add_point(pos)
		c.add_point(pos+Vector2i(size.x, 0))
		c.add_point(pos+size)
		c.add_point(pos+Vector2i(0, size.y))
		c.add_point(pos)
		
		print(size)

		$enemy_path.curve = c
		$enemy_path.queue_redraw()	
	
	$enemy_timer.wait_time = $enemy_timer.wait_time
	$start_timer.start()
	spawn_enemy()

func _on_enemy_timer_timeout() -> void:	
	self.level += 1
	enemy_level = 1+self.level/25
	
	for i in range(enemy_level):
		spawn_enemy()
	
func spawn_enemy() -> void:
	var enemy = enemy_scene.instantiate()

	# Choose a random location on Path2D.
	var enemy_spawn_location = get_node("enemy_path/enemy_spawn_location")
	enemy_spawn_location.progress_ratio = randf()

	# Set the enemy's direction perpendicular to the path direction.
	var direction = enemy_spawn_location.rotation + PI / 2

	# Set the enemy's position to a random location.
	enemy.position = enemy_spawn_location.position

	# Add some randomness to the direction.
	direction += randf_range(-PI / 4, PI / 4)
	#enemy.rotation = direction
	

	# Choose the velocity for the enemy.
	# var min_speed = 100.0
	# var max_speed = max(1000, 100*enemy_level)
	var min_speed = 10+self.enemy_level/2
	var max_speed = 100+self.enemy_level
	var velocity = Vector2(randf_range(min_speed, max_speed), 0.0)
	enemy.linear_velocity = velocity.rotated(direction)
	
	# Set enemy health and damage scaled by time
	enemy.set_level(enemy_level)
	enemy.set_speed(velocity.length())
	enemy.set_scale_factor(scale_factor)

	# Spawn the enemy by adding it to the Main scene.
	add_child(enemy)


func _on_score_timer_timeout() -> void:
	score += 1


func _on_start_timer_timeout() -> void:
	$enemy_timer.start()
	$score_timer.start()
