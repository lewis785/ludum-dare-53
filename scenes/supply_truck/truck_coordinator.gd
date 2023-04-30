extends Node2D

const Structure = preload("res://scenes/structure/structure.gd")
const truck = preload("res://scenes/supply_truck/supply_truck.tscn")

@export var truck_scene : PackedScene
var start_location: Vector2

func structures(nodes : Array[Node]) -> Array[Structure]:
	var structures : Array[Structure] = []
	for node in nodes:
		print(node.get_class())
		if node.is_class("Node2D"):
			var marker : Structure = node
			structures.append(marker)
		
	return structures

# Called when the node enters the scene tree for the first time.
func _ready():
	var start_location = self.position
	#var truck: SupplyTruck = truck_scene.instantiate()
	#var root = self.get_tree().current_scene
	#var structs = structures(root.find_children('*structure*'))
	
	#truck.target_structure = structs[1]
	#add_child(truck)
	pass

func send_truck(location: Vector2):
	var truck: SupplyTruck = truck_scene.instantiate()
	truck.target_structure = location
	add_child(truck)
	
	
func _input(event):
	if(event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT):
		send_truck(self.get_local_mouse_position() + self.global_position)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	pass
