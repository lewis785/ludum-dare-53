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
@export var range: float = 100


@export var projectile: PackedScene = preload("res://scenes/projectile/projectile.tscn")

const supply_store = preload("res://scripts/supply_store.gd")

var tick = false
var time_til_tick: float = 0
var enemies: Array[RigidBody2D] = []
var enemies_in_range: Array[RigidBody2D] = []
var supply_store_instance
var signal_bus

# Called when the node enters the scene tree for the first time.
func _ready():
	signal_bus = get_node("/root/SignalBus")
	label = $StructureHealth
	var range_shape: CollisionShape2D = $StructureArea2D/RangeArea2D/RangeCollisionShape2D
	label.set_text(str(health))
	supply_store_instance = supply_store.new()


	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	tick_manager(delta)
	state_manager()
	pass


func can_take_damage():
	return owned

func can_attack():
	return is_tower and enemies_in_range.size() >= 0

func subtract_damage_from_health(damage):
	health -= damage

func update_health_label(new_health):
	label.set_text(str(new_health))

func reset_tick():
	time_til_tick = 0
	tick = false

func manage_ownership():
	owned = false
	signal_bus.emit_signal('update_ownership')

func setup_connections():
	var projectiles = get_tree().get_nodes_in_group("projectiles")
	if projectiles.size() >= 0:
		for projectile in projectiles:
			print(123)
			projectile.connect("do_damage", subtract_damage_from_enemies)

func state_manager():
	
	if health <= 0:
		update_health_label(0)
		manage_ownership()
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
		remove_enemy_within_range_from_array(current_enemy_name)

func consume_supplies():
	supply_store_instance.remove_supply(supplies_consumption)

func fire_turret(enemy):
	if projectile:
		var instnaced_projectile = projectile.instantiate()
		get_tree().current_scene.add_child(instnaced_projectile)
		instnaced_projectile.global_position = self.global_position
		var instnaced_projectile_rotation = self.global_position.direction_to(enemy.global_position).angle()
		instnaced_projectile.rotation = instnaced_projectile_rotation
	
	
func process_all_attacks():
	for enemy in enemies_in_range:
		consume_supplies()
		fire_turret(enemy)
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

func remove_enemy_within_range_from_array(enemy_name):
	for i in range(enemies_in_range.size()):
			if enemies_in_range[i].name == enemy_name:
				enemies_in_range.remove_at(i)
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


func _on_range_area_2d_body_entered(body):
	var body_parent_name = body.get_parent().name
	if str(body_parent_name).begins_with(parent_name):
		enemies_in_range.append(body)
	pass # Replace with function body.


func _on_range_area_2d_body_exited(body):
	var body_parent_name = body.get_parent().name
	if str(body_parent_name).begins_with(parent_name):
		for i in range(enemies_in_range.size()):
			if enemies_in_range[i].name == body.name:
				enemies_in_range.erase(i)
	pass # Replace with function body.


func _on_do_damage():
	print(123)
	pass # Replace with function body.
