extends Node

var inventory: Dictionary = {}

signal inventory_changed

func AddItemToInventory(item_name: String, amount: int) -> void:
	if !inventory.has(item_name):
		inventory[item_name] = 0
	inventory[item_name] += amount
	inventory_changed.emit()
	
func RemoveItemFromInventory(item_name: String, amount: int) -> void:
	inventory[item_name] -= amount
	inventory_changed.emit()
	if inventory[item_name] <= 0:
		inventory.erase(item_name)

func ClearInventory() -> void:
	inventory.clear()
	inventory_changed.emit()
