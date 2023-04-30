class_name SupplyTruck extends Node2D

var Structure = preload("res://scenes/structure/structure.gd")

@export var speed = 10000.0
@export var target_structure: Structure

var start_position: Vector2
var reached_target = false

func move_towards(delta: float, target: Vector2):
	$truck.velocity = Vector2(0, 0)
	
	var distance_to = (target - $truck.global_position).length()
	if (distance_to <= 10):
		reached_target = true
		return
	
	var direction = (target - $truck.global_position).normalized()
	var angle = rad_to_deg(direction.angle())

	$truck/TruckSprite.flip_v = angle > 90 || angle < -90
	$truck/TruckSprite.rotation = direction.angle()
	$truck/CollisionShape2D.rotation = direction.angle()
	$truck.velocity = direction * speed * delta
	$truck.move_and_slide()

func animate():
	if (reached_target):
		$truck/TruckSprite.play('truck-empty-moving')
	else:	
		$truck/TruckSprite.play('truck-full-moving')
		

func move(delta):
	if (reached_target):	
		move_towards(delta, start_position)
	else:
		move_towards(delta, target_structure.position)

func _ready():
	start_position = self.global_position

func _physics_process(delta):
	animate()
	move(delta)
	
	
	
