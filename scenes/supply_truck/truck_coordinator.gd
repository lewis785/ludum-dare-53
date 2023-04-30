extends Node2D

const Structure = preload("res://scenes/structure/structure.gd")
const truck = preload("res://scenes/supply_truck/supply_truck.tscn")

@export var truck_scene : PackedScene
var start_location: Vector2
var depot_supplies

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
	var depot_supplies = self.get_parent().supply_store_instance
	pass

func send_truck(location: Vector2):
	if (depot_supplies && !depot_supplies.has_required_supplies(20)):
		return
	
	depot_supplies.remove_supply(20)
	var truck: SupplyTruck = truck_scene.instantiate()
	truck.target_structure = location
	add_child(truck)
	
	
func _input(event):
	if(event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT):
		send_truck(self.get_local_mouse_position() + self.global_position)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (depot_supplies == null):
		depot_supplies = self.get_parent().supply_store_instance
		return
