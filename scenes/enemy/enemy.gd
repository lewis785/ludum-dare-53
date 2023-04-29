extends RigidBody2D

@export var health : int
@export var damage : int

# Called when the node enters the scene tree for the first time.
func _ready():
	var mob_types : PackedStringArray = $AnimatedSprite2D.sprite_frames.get_animation_names()
	$AnimatedSprite2D.play(mob_types[randi() % mob_types.size()])


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var targets : Array[Marker2D] = find_targets()
	if len(targets) == 0 :
		return
	move_to_target(targets)
	


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func find_targets() -> Array[Marker2D]:
	var parent : Node = self.get_parent()
	var targets : Array[Node] = parent.find_children("", "Marker2D")
	print(len(targets), " targets")
	
	return markers(targets)
	
func move_to_target(targets : Array[Marker2D]) -> void:
	var target = closest_target(targets)
	
	var vector : Vector2 = (target.position - self.position).normalized()
	
	self.linear_velocity = vector*linear_velocity.length()
	
func closest_target(targets : Array[Marker2D]) -> Marker2D:
	var closest : Marker2D = targets[0]
	var closestDistance = (closest.position - self.position).length()
	
	print("first", closest.position)
	
	for target in targets:
		print("loop", target.position)
		var distance = (target.position - self.position).length()
		if distance < closestDistance:
			closestDistance = distance
			closest = target
	return closest
	
func markers(nodes : Array[Node]) -> Array[Marker2D]:
	var markers : Array[Marker2D] = []
	for node in nodes:
		if node.is_class("Marker2D"):
			var marker : Marker2D = node
			markers.append(marker)
		
	return markers
