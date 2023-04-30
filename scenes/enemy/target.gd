class_name Target extends Marker2D

@export var weight : int = 1
@export var health : int = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func update() -> void:
	var parent = self.get_parent()
	self.position = parent.position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
