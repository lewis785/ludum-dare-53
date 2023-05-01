class_name Structure extends Node2D

enum structure_state{
	town_good,
	town_bad,
	tower_good,
	tower_bad
	}

#@export var health: int = 100
#@export var owned: bool = true
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
	
	_asp = $AudioStreamPlayer2D
	
	init_progress_bars()
	
	_border.hide()
	$entity.priority_weight = 2
	$entity.update_position(self.position)
	
	if is_tower and _animated_sprite:
		$entity.priority_weight = 10
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
	$entity.priority_weight = 2
	_animated_sprite = $StructureArea2D/AnimatedSprite2D
	_animated_sprite.frame = structure_state.tower_good

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	popup_vis(delta)
	tick_manager(delta)
	handle_fire_rate(delta)
	state_manager()
	enemy_store.remove_all_enemies()
	pass

func can_take_damage():
	return $entity.active

func can_attack(enemy):
	return is_tower and enemy_store.enemy_in_range_exists(enemy) and can_fire

func subtract_damage_from_health(damage):
	var active_before = $entity.active
	$entity.take_damage(damage)
	if !$entity.active and active_before:
		emit_update_ownership()

func reset_tick():
	time_til_tick = 0
	tick = false
	
func reset_fire():
	time_til_fire = 0
	can_fire = false

func state_manager():
	handle_death()
	if !$entity.active:
		return
	if tick:
		if can_take_damage():
			process_all_enemies_damage()
			#update_health_label(health)
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
	var alive = $entity.active
	if is_tower and !alive:
		_animated_sprite.frame = structure_state.tower_bad
		update_ownership(false)
	if !is_tower and !alive:
		_animated_sprite.frame = structure_state.town_bad
		update_ownership(false)
	if !is_tower and alive:
		_animated_sprite.frame = structure_state.town_good
		update_ownership(true)
	if is_tower and alive:
		_animated_sprite.frame = structure_state.tower_good
		update_ownership(true)
	if $entity.active:
		$Alert.hide()
	if !$entity.active:
		$Alert.show()
		

func subtract_damage_from_enemies(body):	
	var current_enemy_name = body.name
	if current_enemy_name.contains('SupplyTruck'):
		return
		
	var enemy = get_enemy_entity(body)
	enemy.take_damage(structure_damage)
	if !enemy.active:
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
	$entity.heal(heal)
	
func set_health(value):
	$entity.set_health(value)
	
func popup_vis(delta, add=0):
	if $entity.active and !is_tower:
		var tmp_colour = $Score.get_modulate()
		tmp_colour.a -= delta
		if tmp_colour.a <= 0:
			tmp_colour.a = 0
			
		tmp_colour.a += add
		$Score.set_modulate(tmp_colour)

func update_ownership(value : bool) -> void:
	if $entity.active != value:
		$entity.set_active(value)
		if signal_bus:
			emit_update_ownership()
			
func emit_update_ownership():
	signal_bus.emit_signal('update_ownership', is_tower, $entity.active)

	
func popup_score(score_value):
	$Score.text = "+"+str(score_value)
	$Score.show()
	popup_vis(0, 1)
	
func get_enemy_entity(body):
	return body.find_child("entity")

func _on_structure_area_2d_body_entered(body):
	if body.name.contains('SupplyTruck'):
		unload_truck(body)
		heal(heal_amount)
		update_ownership(true)
		
	var body_parent_name : String = body.get_parent().name
	if body_parent_name.begins_with(parent_name):
		enemy_store.enemies.append(get_enemy_entity(body))

func _on_range_area_2d_body_entered(body):
	if body.name.contains('SupplyTruck'):
		return
	var body_parent_name : String = body.get_parent().name
	if body_parent_name.begins_with(parent_name):
		enemy_store.enemies_in_range.append(get_enemy_entity(body))

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
		popup_score(20)
		consume_supplies(supplies_consumption)
		signal_bus.emit_signal("score_update", 20)
