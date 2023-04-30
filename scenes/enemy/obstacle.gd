class_name Obstacle extends Node2D

@export var radius : int = 120
@export var min_radius : int = 60

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Area2D/CollisionShape2D.shape.radius = self.radius


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name.contains("enemy"):
		var enemy = body
		enemy.add_obstacle(self)


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name.contains("enemy"):
		var enemy = body
		enemy.remove_obstacle(self)
