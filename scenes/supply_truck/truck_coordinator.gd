extends Node2D

const Structure = preload("res://scenes/structure/structure.gd")
const truck = preload("res://scenes/supply_truck/supply_truck.tscn")

@export var truck_scene : PackedScene
var start_location: Vector2
var depot_supplies

func structures(nodes : Array[Node]) -> Array[Structure]:
	var structures : Array[Structure] = []
	for node in nodes:
		if node.is_class("Node2D"):
			var marker : Structure = node
			structures.append(marker)
		
	return structures

# Called when the node enters the scene tree for the first time.
func _ready():
	var start_location = self.position
	var depot_supplies = self.get_parent().supply_store_instance
	var signal_bus = get_node("/root/SignalBus")
	signal_bus.connect('send_supply_to_structure', send_to_structure)

func send_to_structure(structure: Structure):
	send_truck(structure)

func send_truck(structure: Structure):
	if (depot_supplies && !depot_supplies.has_required_supplies(20)):
		return
	
	depot_supplies.remove_supply(20)
	var truck: SupplyTruck = truck_scene.instantiate()
	truck.target_structure = structure.position
	add_child(truck)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (depot_supplies == null):
		depot_supplies = self.get_parent().supply_store_instance
		return
