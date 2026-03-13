extends Node

# Stores name of each item in the player's hotbar
@export var preset_hotbar: Array[String]
@export var hotbar_limit = 9
var current_hotbar: Array[String]
var hotbar_equipment_slots: Array[String]
var hotbar_inventory_slots: Array[String]

signal hotbar_changed

func _ready() -> void:
	current_hotbar = preset_hotbar
	InventoryManager.inventory_changed.connect(ReSetupHotbar)

func ReSetupHotbar() -> void:
	var num_inventory_slots = hotbar_limit - len(hotbar_equipment_slots)
	if len(hotbar_inventory_slots) < num_inventory_slots:
		# Filler for current function until add inventory
		for item in InventoryManager.inventory.keys():
			if item not in hotbar_inventory_slots:
				hotbar_inventory_slots.append(item)
	hotbar_changed.emit()
