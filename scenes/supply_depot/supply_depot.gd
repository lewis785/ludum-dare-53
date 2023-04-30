extends Node2D

@export var max_supply = 100
@export var health = 1000
@export var refill_rate = 10
@export var supply = 0
var acc = 0

func _ready():
	$DepotSprite.play('depot-healthy')
	$entity.update_position(self.position)
	
	$entity.max_health = health
	$entity.set_health(health)

