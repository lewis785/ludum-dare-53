extends Node2D

@export var max_supply = 100
@export var refill_rate = 10
@export var supply = 0
var acc = 0

func _ready():
	$truck_coordinator/SupplyStore.set_supply_capacity(max_supply)
	$truck_coordinator/SupplyStore.add_supply(supply)
	$RefillTimer.start()
	$DepotSprite.play('depot-healthy')

func refill():
	$truck_coordinator/SupplyStore.add_supply(refill_rate)
	
func _on_refill_timer_timeout():
	refill()

