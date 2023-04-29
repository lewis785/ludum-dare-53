extends Node2D

var HEALTH = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	$TownHealth.set_text("ok")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_town_area_2d_body_entered(body):
	if body.name == "enemy":
		$TownHealth.set_text("no ok")
		print("Enemy Attacking")
	pass # Replace with function body.
