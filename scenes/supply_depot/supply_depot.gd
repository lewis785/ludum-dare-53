extends Node2D

@export var health = 100

func _ready():
	$DepotSprite.play('depot-healthy')
	$entity.update_position(self.position)
	
	$entity.max_health = health
	$entity.set_health(health)

