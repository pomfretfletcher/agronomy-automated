extends Node

var inventory: Dictionary = {}

signal inventory_changed(item_changed)
signal inventory_cleared
	
func AddItemToInventory(item_name: String, amount: int) -> void:
	if !inventory.has(item_name):
		inventory[item_name] = 0
	inventory[item_name] += amount
	inventory_changed.emit(item_name)

func AddItemToInventoryWithoutSignal(item_name: String, amount: int) -> void:
	if !inventory.has(item_name):
		inventory[item_name] = 0
	inventory[item_name] += amount
	
func TakeItemFromInventory(item_name: String, amount: int) -> void:
	inventory[item_name] -= amount
	if inventory[item_name] <= 0:
		inventory.erase(item_name)
	inventory_changed.emit(item_name)

func TakeItemFromInventoryWithoutSignal(item_name: String, amount: int) -> void:
	inventory[item_name] -= amount
	
func RemoveItemFromInventory(item_name: String) -> void:
	inventory.erase(item_name)
	inventory_changed.emit(item_name)

func RemoveItemFromInventoryWithoutSignal(item_name: String) -> void:
	inventory.erase(item_name)
	
func ClearInventory() -> void:
	inventory.clear()
	inventory_cleared.emit()
