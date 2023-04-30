extends Node

@export var supply_capacity = 100;
@export var supplies = 0;

func add_supply(supply_amount: int):
	if (supplies + supply_amount > supply_capacity):
		supplies = supply_capacity
		update_label()
		return supplies + supply_amount - supply_capacity
	supplies += supply_amount
	update_label()
	return 0

func has_required_supplies(required_supplies: int):
	return required_supplies <= supplies
	
func remove_supply(supply_amount: int):
	supplies -= supply_amount
	update_label()

func update_label():
	var format = "%s / %s"
	$SupplyText.text = format % [supplies, supply_capacity]
