extends RigidBody2D

@export var health : int
@export var damage : int

# Called when the node enters the scene tree for the first time.
func _ready():
	var mob_types : PackedStringArray = $AnimatedSprite2D.sprite_frames.get_animation_names()
	$AnimatedSprite2D.play(mob_types[randi() % mob_types.size()])


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var targets : Array[Node] = find_targets()
	if len(targets) == 0 :
		return
	move_to_target(targets[0])
	


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func find_targets() -> Array[Node]:
	var parent : Node = self.get_parent()
	var targets : Array[Node] = parent.find_children("", "Marker2D")
	print(len(targets), " targets")
	
	return targets
	
func move_to_target(target : Marker2D) -> void:
	print(target.position)
	
	var vector : Vector2 = (target.position - self.position).normalized()
	
	self.linear_velocity = vector*linear_velocity.length()
	
