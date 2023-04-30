class_name Entity extends Node2D

@export var friendly : bool = true
@export var alive : bool = true
@export var active : bool = true
@export var health : int = 1
@export var max_health : int = 10
@export var damage : int = 0
@export var priority_weight : int = 1

signal health_update

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if friendly:
		add_to_group("ally")
	else:
		add_to_group("enemy")
		
	if active:
		notify_health(health)
	

func update_position(pos) -> void:
	self.position = pos

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_active(value: bool) -> void:
	if value:
		activate()
	else:
		deactivate()

func activate() -> void:
	notify_health(health)
	active = true
	
func deactivate() -> void:
	active = false

func take_damage(attack : int) -> void:
	set_health(max(0, health - attack))
	
	if health == 0:
		alive = false
		deactivate()
		
func get_targets() -> Array[Node2D]:
	var target_group = "enemy"
	if !friendly:
		target_group = "ally"
	
	var entities = get_tree().get_nodes_in_group(target_group)
	var targets : Array[Node2D] = []
	
	for entity in entities:
		if is_target(entity):
			targets.append(entity)
	
	return targets
	
func is_target(entity) -> bool:
	return entity.friendly != friendly and entity.alive and entity.active
	
func attack(entity) -> void:
	entity.take_damage(damage)
	
func heal(healing : int) -> void:
	set_health(max(max_health, health + healing))
	
	
func set_health(value : int) -> void:
	health = max(0, min(value, max_health))
	
	
func notify_health(value) -> void:
	health_update.emit((value*100)/max_health)
