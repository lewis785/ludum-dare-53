extends Node2D

const Structure = preload("res://scenes/structure/structure.gd")
const truck = preload("res://scenes/supply_truck/supply_truck.tscn")

@export var truck_scene : PackedScene
@export var available_trucks = 5;
var start_location: Vector2
var truck_indicator

func structures(nodes : Array[Node]) -> Array[Structure]:
	var structures : Array[Structure] = []
	for node in nodes:
		if node.is_class("Node2D"):
			var marker : Structure = node
			structures.append(marker)
		
	return structures

# Called when the node enters the scene tree for the first time.
func _ready():
	var root = self.get_tree().current_scene
	truck_indicator = get_tree().get_first_node_in_group('TruckIndicator')
	truck_indicator.set_truck_limit(available_trucks)
	var start_location = self.position
	var signal_bus = get_node("/root/SignalBus")
	signal_bus.connect('send_supply_to_structure', send_to_structure)
	signal_bus.connect('update_ownership', ownership_update)

func ownership_update(is_tower, claimed):
	print("Is tower: ", is_tower)
	print("Claimed: ", claimed)
	if is_tower:
		return
	if claimed:
		create_truck()
	else:
		destroy_truck()
	
func create_truck():
	available_trucks += 1
	truck_indicator.add_truck()

func destroy_truck():
	available_trucks -= 1
	truck_indicator.remove_truck()

func send_to_structure(structure: Structure):
	send_truck(structure)

func send_truck(structure: Structure):
	if (!$SupplyStore.has_required_supplies(20) || available_trucks <= 0):
		return
	available_trucks -= 1
	$SupplyStore.remove_supply(20)
	var SupplyBar = get_node("../SupplyBar")
	SupplyBar.set_percentage($SupplyStore.supplies)
	var truck: SupplyTruck = truck_scene.instantiate()
	truck.target_structure = structure
	truck.truck_indicator = truck_indicator
	truck.trucwk_id = truck_indicator.next_free_truck()
	
	add_child(truck)

func _on_supply_depot_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if !body.name.contains('SupplyTruck'):
		return
	
	if body.reached_target:
		available_trucks += 1
		truck_indicator.set_truck_status(body.truck_id, "")
		body.queue_free()
		

