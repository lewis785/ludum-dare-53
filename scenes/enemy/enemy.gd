class_name Enemy extends RigidBody2D

@export var level : int = 1
@export var health : int
@export var damage : int

var obstacles : Array[Obstacle] = []

# Called when the node enters the scene tree for the first time.
func _ready():
	var mob_types : PackedStringArray = $AnimatedSprite2D.sprite_frames.get_animation_names()
	$AnimatedSprite2D.play(mob_types[randi() % mob_types.size()])
	
	health = level
	damage = level


func set_level(level) -> void:
	self.level = level
	self.health = level
	self.damage = level

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if health <= 0:
		queue_free()
		return
	
	var targets : Array[Target] = find_targets()
	if len(targets) == 0 :
		return
	move_to_target(targets)
	


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func find_targets() -> Array[Target]:
	var targets : Array[Node] = get_tree().get_nodes_in_group("targets")
	#print("targets...", targets)
	
	return markers(targets)
	
func move_to_target(targets : Array[Target]) -> void:
	var target = closest_target(targets)
		
	var vector : Vector2 = (target.position - self.position).normalized()
	if obstacles.size() > 0:
		vector = adjust_for_obstacles(target, vector)
	
	self.linear_velocity = vector*linear_velocity.length()
	
func closest_target(targets : Array[Target]) -> Target:
	var closest : Target = targets[0]
	var closestDistance = distance(self.position, closest)
	
	for target in targets:
		var distance = distance(self.position, target)
		if distance < closestDistance:
			closestDistance = distance
			closest = target
	return closest
	
func distance(position : Vector2, target : Target) -> float:
	return (target.position - position).length()/target.weight
	
func markers(nodes : Array[Node]) -> Array[Target]:
	var markers : Array[Target] = []
	for node in nodes:
		if node.is_class("Marker2D"):
			var marker : Target = node
			markers.append(marker)
		
	return markers

func adjust_for_obstacles(target : Target, velocity : Vector2) -> Vector2:
	var adjusted : Vector2 = Vector2(0,0)
	
	var min_distance = 9223372036854775807
	
	for obstacle in obstacles:
		var vector = self.position - obstacle.position
		var avoid = vector.rotated(PI/2).normalized()
		var distance = max(0, vector.length()-obstacle.min_radius)/(obstacle.radius-obstacle.min_radius)
		
		if avoid.dot(target.position - obstacle.position) < 0:
			avoid = -avoid
		
		
		adjusted += avoid*(1-distance)
		min_distance = min(min_distance, distance)
	
	return (adjusted+min_distance*velocity).normalized()
		

func add_obstacle(obstacle: Obstacle):
	obstacles.append(obstacle)
		
func remove_obstacle(obstacle: Obstacle):
		for i in range(len(obstacles)):
			if obstacles[i] == obstacle:
				obstacles.remove_at(i)
				return

