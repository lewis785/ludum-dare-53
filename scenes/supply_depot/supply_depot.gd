extends Node2D

@export var max_supply = 100
@export var health = 100
@export var refill_rate = 10
@export var supply = 0
var acc = 0

const status_bar_manager = preload("res://scripts/status_bar_manager.gd")

func _ready():
	$truck_coordinator/SupplyStore.set_supply_capacity(max_supply)
	$truck_coordinator/SupplyStore.add_supply(supply)
	$RefillTimer.start()
	$DepotSprite.play('depot-healthy')
	
	status_bar_manager.init_health_bar($health/ProgressBar, $health/Label, health)
	status_bar_manager.init_supply_bar($supply/ProgressBar, $supply/Label, supply)


func refill():
	$truck_coordinator/SupplyStore.add_supply(refill_rate)
	
func _on_refill_timer_timeout():
	refill()

