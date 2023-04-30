extends Node2D


@export var max_supply = 100
@export var refill_rate = 10
@export var supply = 0
var acc = 0
const supply_store = preload("res://scripts/supply_store.gd")
var supply_store_instance

func _ready():
	supply_store_instance = supply_store.new()
	supply_store_instance.supply_capacity = max_supply
	supply_store_instance.supplies = supply
	$RefillTimer.start()
	$DepotSprite.play('depot-healthy')

func refill():
	if max_supply == supply:
		return
	supply_store_instance.add_supply(refill_rate)
	
func _on_refill_timer_timeout():
	refill()
