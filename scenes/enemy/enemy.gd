class_name Enemy extends RigidBody2D

@export var level : int = 1

var obstacles : Array[Obstacle] = []
var target 
var target_check_limit: float = 0.2
var time_since_target_check : float = target_check_limit
var attack_speed : float = 0.5
var time_since_attack : float = attack_speed
var base_speed : float = 100
var scale_factor: int = 1
var attacking : bool

enum animations {
	attack1,
	attack2,
	walk
}

# Called when the node enters the scene tree for the first time.
func _ready():
	play_animation(animations.walk)
	
	self.lock_rotation = true
	
	set_level(level)
	
func play_animation(frames : int) -> void:
	var mob_types : PackedStringArray = $AnimatedSprite2D.sprite_frames.get_animation_names()
	$AnimatedSprite2D.play(mob_types[frames])

func set_speed(speed : float) -> void:
	self.base_speed = speed
	
func set_scale_factor(sf : int) -> void:
	self.scale_factor = sf

func set_level(level) -> void:
	self.level = level
	$entity.health = level
	$entity.damage = level
	
	var scaled = Vector2(1,1)*max(1, log(level))
	
	$AnimatedSprite2D.transform = $AnimatedSprite2D.transform.scaled(scaled)
	$CollisionShape2D.transform = $CollisionShape2D.transform.scaled(scaled)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	time_since_target_check += _delta
	time_since_attack += _delta
	
	if !$entity.active:
		queue_free()
		return
	
	var targets = $entity.get_targets()
	
	if len(targets) == 0 :
		return
		
	move_to_target(targets)
	
	process_attack_state()
	
func process_attack_state() -> void:
	var previously_attacking = attacking
	attacking = in_target_range()
	
	if previously_attacking and !attacking:
		play_animation(animations.walk)
	if !previously_attacking and attacking:
		play_animation(randi() % 2)
		
	if attacking and time_since_attack > attack_speed:
		time_since_attack = 0
		$entity.attack(target)

func in_target_range() -> bool:
	return (self.position - target.position).length() < 10*scale_factor

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func find_targets():	
	return $entity.get_targets()
	
func move_to_target(targets) -> void:
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
	
	if !target.active:
		speed = min(current_speed*2, self.base_speed)
	
	return speed
	
	
func closest_target(targets):
	if time_since_target_check < target_check_limit:
		return target
		
	time_since_target_check = 0
	
	var closest = targets[0]
	var closestDistance = distance(self.position, closest)
	
	for target in targets:
		var distance = distance(self.position, target)
		if distance < closestDistance:
			closestDistance = distance
			closest = target
	
	target = closest
	
	return closest
	
func distance(position : Vector2, target ) -> float:
	return (target.position - position).length()/target.priority_weight
	

func adjust_for_obstacles(target, velocity : Vector2) -> Vector2:
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

