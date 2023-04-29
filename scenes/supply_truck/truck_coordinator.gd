extends Node2D

@export var truck: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	var trucker = truck.instantiate()
	add_child(trucker)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
