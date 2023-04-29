extends Node2D

@export var max_supply = 100
@export var refill_rate = 10
@export var supply = 0
var acc = 0

func refill():
	if max_supply == supply:
		return
	if supply + refill_rate > max_supply:
		supply = max_supply
	supply += refill_rate
	print(supply)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	acc += delta
	if acc >= 1:
		refill()
		acc = 0
	pass
