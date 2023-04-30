class_name Structure extends Node2D

enum structure_state{
	town_good,
	town_bad,
	tower_good,
	tower_bad
	}

@export var health: int = 100
@export var owned: bool = true
@export var tick_threshold: float = 1
@export var label: Label
@export var is_tower: bool
@export var structure_damage: int = 10
@export var supplies_consumption: int = 1
@export var range: float = 100
@export var rate_of_fire: float = 0.1
@export var parent_name : String = 'spawn'
@export var heal_amount: int = 20

var local_name:	String

@export var projectile: PackedScene = preload("res://scenes/projectile/projectile.tscn")

const enemy_store_res = preload("res://scripts/enemy_store.gd")
var _supply_store: SupplyStore

var tick = false
var can_fire = false
var time_til_fire: float = 0
var time_til_tick: float = 0
var enemy_store: EnemyStore
var signal_bus
var _animated_sprite: AnimatedSprite2D
var _border
var _target
var _asp : AudioStreamPlayer2D
var _health_bar: Control
var _supply_bar: Control

# Called when the node enters the scene tree for the first time.
func _ready():
	self.local_name = self.name
	$ScoreTimer.start()
	signal_bus = get_node("/root/SignalBus")
	signal_bus.connect("do_damage_to_enemy", subtract_damage_from_enemies)
	
	_animated_sprite = $StructureArea2D/AnimatedSprite2D
	_border = $StructureArea2D/Borders
	_supply_store = $SupplyStore
	
	_health_bar = $health/ProgressBar
	_supply_bar = $supply/ProgressBar
	
	_target = $target
	_asp = $AudioStreamPlayer2D
	
	init_progress_bars()
	
	_border.hide()
	_target.weight = 1
	if is_tower and _animated_sprite:
		_target.weight = 10
		_animated_sprite.frame = structure_state.tower_good
	
	var range_shape: CollisionShape2D = $RangeArea2D/RangeCollisionShape2D
	enemy_store = enemy_store_res.new()
	pass # Replace with function body.

func _init():
	pass
	
func init_progress_bars():
	_health_bar = $health	
	_supply_bar = $supply

func set_tower():
	is_tower = true
	$target.weight = 10
	_animated_sprite = $StructureArea2D/AnimatedSprite2D
	_animated_sprite.frame = structure_state.tower_good

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	tick_manager(delta)
	handle_fire_rate(delta)
	state_manager()
	enemy_store.remove_all_enemies()
	pass

func can_take_damage():
	return owned

func can_attack(enemy):
	return is_tower and enemy_store.enemy_in_range_exists(enemy) and can_fire

func subtract_damage_from_health(damage):
	health -= damage
	if health <= 0:
		owned = false
		print("ded lol")
		manage_ownership()
		

func update_health_label(new_health):
	_health_bar.set_percentage(new_health)

func reset_tick():
	time_til_tick = 0
	tick = false
	
func reset_fire():
	time_til_fire = 0
	can_fire = false


func manage_ownership():
	signal_bus.emit_signal('update_ownership')


func state_manager():
	handle_death()
	if health <= 0:
		update_health_label(0)
		return
	if tick:
		if can_take_damage():
			process_all_enemies_damage()
			update_health_label(health)
		reset_tick()
		
	for enemy in enemy_store.enemies_in_range:
		if can_attack(enemy):
			process_attacks(enemy)
			reset_fire()	

func process_all_enemies_damage():
	for enemy in enemy_store.enemies:
		if enemy_store.enemy_exists(enemy):
			var damage = enemy.damage
			subtract_damage_from_health(damage)

func handle_death():
	if is_tower and health <= 0:
		_animated_sprite.frame = structure_state.tower_bad
		owned = false
	if !is_tower and health <= 0:
		_animated_sprite.frame = structure_state.town_bad
		owned = false
	if !is_tower and health >= 1:
		_animated_sprite.frame = structure_state.town_good
		owned = true
	if is_tower and health >= 1:
		_animated_sprite.frame = structure_state.tower_good
		owned = true
	if owned:
		$Alert.hide()
	if !owned:
		$Alert.show()
		

func subtract_damage_from_enemies(enemy):
	var current_enemy_name = enemy.name
	if current_enemy_name.contains('SupplyTruck'):
		return
	enemy.health -= structure_damage
	if enemy.health <= 0:
		enemy_store.add_enemy_to_remove(enemy)


func consume_supplies(amount):
	$SupplyStore.remove_supply(amount)
	$supply.set_percentage($SupplyStore.supplies)

func fire_turret(enemy):
	if projectile:
		var instnaced_projectile = projectile.instantiate()
		get_tree().current_scene.add_child(instnaced_projectile)
		instnaced_projectile.global_position = self.global_position
		var instnaced_projectile_rotation = self.global_position.direction_to(enemy.global_position).angle()
		instnaced_projectile.rotation = instnaced_projectile_rotation
		instnaced_projectile._asp.play()
	
	
func process_attacks(enemy):
	if enemy_store.enemy_in_range_exists(enemy):
		consume_supplies(1)
		fire_turret(enemy)

func handle_fire_rate(delta):
	time_til_fire += delta
	if time_til_fire >= rate_of_fire and _supply_store.supplies >= 0:
		can_fire = true
	pass

func tick_manager(delta):
	time_til_tick += delta
	if time_til_tick >= tick_threshold:
		tick = true
	pass

func unload_truck(truck: SupplyTruck):
	if(truck.target_structure != self):
		return
		
	var truck_supply = truck.get_node('SupplyStore')
	$SupplyStore.add_supply(truck_supply.remove_supply(truck_supply.supplies))
	_supply_bar.set_percentage($SupplyStore.supplies)
	_asp.play()

func heal(heal):
	var temp_health = health
	temp_health += heal
	if temp_health >= 100:
		health = 100
		return
	health = temp_health
	

func _on_structure_area_2d_body_entered(body):
	if body.name.contains('SupplyTruck'):
		unload_truck(body)
		heal(heal_amount)
		owned = true
		manage_ownership()
		signal_bus.emit_signal('update_ownership')
	var body_parent_name = body.get_parent().name
	if str(body_parent_name).begins_with(parent_name):
		enemy_store.enemies.append(body)

func _on_range_area_2d_body_entered(body):
	if body.name.contains('SupplyTruck'):
		return
	var body_parent_name : String = body.get_parent().name
	if body_parent_name.begins_with(parent_name):
		enemy_store.enemies_in_range.append(body)

func _on_structure_area_2d_body_exited(body):
	# enemy_store.add_enemy_to_remove(body)
	pass

func _on_range_area_2d_body_exited(body):
	# enemy_store.add_enemy_to_remove(body)
	pass


func _on_structure_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx):
	if event.is_action_pressed("active"):
		signal_bus.emit_signal("send_supply_to_structure", self)
	pass # Replace with function body.


func _on_structure_area_2d_mouse_entered():
	_border.show()
	pass # Replace with function body.


func _on_structure_area_2d_mouse_exited():
	_border.hide()
	pass # Replace with function body.

func _on_score_timer_timeout():
	if !is_tower && $SupplyStore.has_required_supplies(supplies_consumption):
		consume_supplies(supplies_consumption)
		signal_bus.emit_signal("score_update", 20)
