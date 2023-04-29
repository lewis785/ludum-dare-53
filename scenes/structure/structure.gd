class_name Structure extends Node2D

@export var health: int = 100
@export var owned: bool = true
@export var supplies: int = 100
@export var tick_threshold: float = 1
@export var parent_name = 'spawn'
@export var label: Label
@export var is_tower: bool
@export var structure_damage: int = 10
@export var supplies_consumption: int = 1

@export var projectile: PackedScene = preload("res://scenes/projectile/projectile.tscn")

var tick = false
var time_til_tick: float = 0
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
	var current_enemy_name = enemy.name
	enemy.health -= structure_damage
	if enemy.health <= 0:
		remove_enemy_from_array(current_enemy_name)

func consume_supplies():
	supplies -= supplies_consumption

func fire_turret(enemy):
	if projectile:
		var instnaced_projectile = projectile.instantiate()
		get_tree().current_scene.add_child(instnaced_projectile)
		instnaced_projectile.global_position = self.global_position
		var instnaced_projectile_rotation = self.global_position.direction_to(enemy.global_position).angle()
		instnaced_projectile.rotation = instnaced_projectile_rotation
	
	

func process_all_attacks():
	for enemy in enemies:
		consume_supplies()
		fire_turret(enemy)
		subtract_damage_from_enemies(enemy)
		break

func tick_manager(delta):
	time_til_tick += delta
	if time_til_tick >= tick_threshold:
		tick = true
	pass
	

func remove_enemy_from_array(enemy_name):
	for i in range(enemies.size()):
			if enemies[i].name == enemy_name:
				enemies.remove_at(i)
				return

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
