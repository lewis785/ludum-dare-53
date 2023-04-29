extends CharacterBody2D

@export const speed = 30.0
	

func _physics_process(delta):
	velocity.x = 0;
		
	if Input.is_action_pressed('ui_left'):
		velocity.x = -speed
		$TruckSprite.play('truck-moving')
		$TruckSprite.flip_h = true
	
	if Input.is_action_pressed('ui_right'):
		velocity.x = speed
		$TruckSprite.play('truck-moving')
		$TruckSprite.flip_h = false
		
	move_and_slide()
