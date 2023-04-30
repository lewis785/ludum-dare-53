class_name SupplyTruck extends CharacterBody2D

var Structure = preload("res://scenes/structure/structure.gd")

@export var speed = 10000.0
@export var target_structure: Structure
var truck_indicator
var truck_id: int

var start_position: Vector2
var reached_target = false

func move_towards(delta: float, target: Vector2):
	velocity = Vector2(0, 0)
	
	var distance_to = (target - global_position).length()
	if (distance_to <= 10):
		truck_indicator.set_truck_status(truck_id, "returning")
		reached_target = true
		return
	
	var direction = (target - self.global_position).normalized()
	var angle = rad_to_deg(direction.angle())

	$TruckSprite.flip_v = angle > 90 || angle < -90
	$TruckSprite.rotation = direction.angle()
	$CollisionShape2D.rotation = direction.angle()
	velocity = direction * speed * delta
	move_and_slide()

func animate():
	if (reached_target):
		$TruckSprite.play('truck-empty-moving')
	else:	
		$TruckSprite.play('truck-full-moving')
		

func move(delta):
	if (reached_target):	
		move_towards(delta, start_position)
	else:
		move_towards(delta, target_structure.position)

func _ready():
	start_position = self.global_position
	truck_indicator.set_truck_status(truck_id, "delivering")

func _physics_process(delta):
	animate()
	move(delta)
	
	
	
