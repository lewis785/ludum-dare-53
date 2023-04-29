extends Node2D

@export var level : int = 1
@export var enemy_scene : PackedScene
var score

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	new_game()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func new_game():
	score = 0
	$start_timer.start()

func _on_enemy_timer_timeout() -> void:	
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
	enemy.rotation = direction

	# Choose the velocity for the enemy.
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	enemy.linear_velocity = velocity.rotated(direction)
	
	# Set enemy health and damage scaled by time
	self.level += 1
	enemy.set_level(self.level)

	# Spawn the enemy by adding it to the Main scene.
	add_child(enemy)


func _on_score_timer_timeout() -> void:
	score += 1


func _on_start_timer_timeout() -> void:
	$enemy_timer.start()
	$score_timer.start()
