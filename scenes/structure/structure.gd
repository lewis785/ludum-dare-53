extends Node2D

@export var health: int = 100
@export var owned: bool = true
@export var supplies: int = 100
@export var tick_threshold: float = 1
@export var parent_name = 'spawn'
@export var label: Label
@export var is_tower: bool
@export var structure_damage: int = 10
@export var supplies_consumption: int = 1

var tick = false
var time_til_tick: int = 0
var enemies: Array[RigidBody2D] = []

# Called when the node enters the scene tree for the first time.
func _ready():
	label = $StructureHealth
	label.set_text(str(health))
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	tick_manager(delta)
	state_manager()
	pass


func can_take_damage():
	return owned

func can_attack():
	return is_tower

func subtract_damage_from_health(damage):
	health -= damage

func update_health_label(new_health):
	label.set_text(str(new_health))

func reset_tick():
	time_til_tick = 0
	tick = false

func state_manager():
	if health <= 0:
		update_health_label(0)
		owned = false
		return
	if tick:
		if can_take_damage():
			process_all_enemies_damage()
			update_health_label(health)
		if can_attack():
			process_all_attacks()
		reset_tick()


func process_all_enemies_damage():
	for enemy in enemies:
		subtract_damage_from_health(enemy.damage)

func subtract_damage_from_enemies(enemy):
	enemy.health -= structure_damage

func consume_supplies():
	supplies -= supplies_consumption

func process_all_attacks():
	for enemy in enemies:
		consume_supplies()
		subtract_damage_from_enemies(enemy)
		break

func tick_manager(delta):
	time_til_tick += delta
	if time_til_tick >= tick_threshold:
		tick = true
	pass
	

func _on_structure_area_2d_body_entered(body):
	var body_parent_name = body.get_parent().name
	if str(body_parent_name).begins_with(parent_name):
		enemies.append(body)
	pass # Replace with function body.


func _on_structure_area_2d_body_exited(body):
	var body_parent_name = body.get_parent().name
	if str(body_parent_name).begins_with(parent_name):
		for i in range(enemies.size()):
			if enemies[i].name == body.name:
				enemies.erase(i)
	pass # Replace with function body.
