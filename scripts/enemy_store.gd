class_name EnemyStore extends Node

var enemies: Array[RigidBody2D] = []
var enemies_in_range: Array[RigidBody2D] = []
var enemies_to_remove: Array[RigidBody2D] = []

func add_enemy_to_remove(enemy):
	enemies_to_remove.append(enemy)

func enemy_exists(enemy):
	return enemies.find(enemy) >= 0 and !enemies_to_remove.find(enemy)

func enemy_in_range_exists(enemy):
	print(enemies_in_range.find(enemy))
	return enemies_in_range.find(enemy) >= 0 and enemies_to_remove.find(enemy) == -1

func remove_all_enemies():
	for enemy_to_remove in enemies_to_remove:
		print("removing...", enemy_to_remove)
		var enemy_idx = enemies.find(enemy_to_remove)
		var enemy_in_range_idx = enemies_in_range.find(enemy_to_remove)
		enemies.remove_at(enemy_idx)
		enemies_in_range.remove_at(enemy_in_range_idx)
		
func remove_enemy_from_array(enemy_name):
	var found_enemy_idx = enemies.find(enemy_name)
	if found_enemy_idx >= 0:
		enemies[found_enemy_idx].queue_free()
		enemies.remove_at(found_enemy_idx)

func remove_enemy_within_range_from_array(enemy_name):
	var found_enemy_idx = enemies_in_range.find(enemy_name)
	if found_enemy_idx >= 0:
		enemies_in_range[found_enemy_idx].queue_free()
		enemies_in_range.remove_at(found_enemy_idx)
