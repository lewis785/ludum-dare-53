class_name Enemy extends RigidBody2D

@export var level : int = 1
@export var health : int = 1
@export var damage : int = 1

var obstacles : Array[Obstacle] = []
var target : Target 
var target_check_limit: float = 2
var time_since_target_check : float = target_check_limit
var base_speed : float = 100
var scale_factor: int = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	var mob_types : PackedStringArray = $AnimatedSprite2D.sprite_frames.get_animation_names()
	$AnimatedSprite2D.play(mob_types[randi() % mob_types.size()])
	
	self.lock_rotation = true
	
	health = level
	damage = level

func set_speed(speed : float) -> void:
	self.base_speed = speed
	
func set_scale_factor(sf : int) -> void:
	self.scale_factor = sf

func set_level(level) -> void:
	self.level = level
	self.health = level
	self.damage = level
	
	var scaled = Vector2(1,1)*max(1, log(level*level))
	print("scale: ", scaled)
	
	print("sprite before: ", $AnimatedSprite2D.transform)
	$AnimatedSprite2D.transform = $AnimatedSprite2D.transform.scaled(scaled)
	print("sprite: ", $AnimatedSprite2D.transform)
	
	
	print("collision before: ", $CollisionShape2D.transform)
	$CollisionShape2D.transform = $CollisionShape2D.transform.scaled(scaled)
	print("collision: ", $CollisionShape2D.transform)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	time_since_target_check += _delta
	
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
	
	return convert_targets(targets)
	
func move_to_target(targets : Array[Target]) -> void:
	var target = closest_target(targets)
		
	var vector : Vector2 = (target.position - self.position).normalized()
	if obstacles.size() > 0:
		vector = adjust_for_obstacles(target, vector)
	
	self.linear_velocity = vector * determine_speed()

	
func determine_speed() -> float:
	var current_speed = self.linear_velocity.length()
	var distance = distance(self.position, target) * scale_factor
	var adjusted = distance*distance/4
	
	var target_speed = min(distance, self.base_speed)
	var speed = min(target_speed, current_speed+100)
	
	if target.get_parent().health <= 0:
		speed = min(current_speed*2, self.base_speed)
	
	return speed
	
	
func closest_target(targets : Array[Target]) -> Target:
	if time_since_target_check < target_check_limit:
		return target
		
	time_since_target_check = 0
	
	var closest : Target = targets[0]
	var closestDistance = distance(self.position, closest)
	
	for target in targets:
		var distance = distance(self.position, target)
		if distance < closestDistance:
			closestDistance = distance
			closest = target
	
	target = closest
	
	return closest
	
func distance(position : Vector2, target : Target) -> float:
	return (target.position - position).length()/target.weight
	
func convert_targets(nodes : Array[Node]) -> Array[Target]:
	var markers : Array[Target] = []
	for node in nodes:	
		var parent = node.get_parent()
		if !parent.is_in_group("structures"):
			continue
			
		var structure : Structure = parent
		if !structure.owned:
			continue
				
		
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

