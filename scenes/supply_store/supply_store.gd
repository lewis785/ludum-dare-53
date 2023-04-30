class_name SupplyStore extends Node

@export var supply_capacity = 100;
@export var supplies = 0;

func _ready():
	pass
	
func set_supply_capacity(capacity: int):
	supply_capacity = capacity

func add_supply(supply_amount: int):
	if (supplies + supply_amount > supply_capacity):
		supplies = supply_capacity
		return supplies + supply_amount - supply_capacity
	supplies += supply_amount
	return 0

func has_required_supplies(required_supplies: int):
	return required_supplies <= supplies
	
func remove_supply(supply_amount: int):
	supplies -= supply_amount
	return supply_amount
