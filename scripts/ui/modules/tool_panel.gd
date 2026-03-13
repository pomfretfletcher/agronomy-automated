extends PanelContainer

@onready var tool_slot: EquipmentSlot = $MarginContainer/HBoxContainer/ToolSlot
@onready var seed_slot: EquipmentSlot = $MarginContainer/HBoxContainer/SeedSlot
@onready var slot_container: HBoxContainer = $MarginContainer/HBoxContainer

@export var inventory_slot_framework: PackedScene

var equipment_slots: Array[EquipmentSlot]
var inventory_slots: Dictionary[String, InventorySlot]
var slots: Array

var current_slot: int = 0

func _ready() -> void:
	# Setup initial focus on slot 1, item 1
	equipment_slots = [tool_slot, seed_slot]
	slots = [tool_slot, seed_slot]
	FocusSlots()
	
	# Make it so whenever the inventory changes, we display the new inventory
	HotbarManager.hotbar_changed.connect(DisplayItems)
	
func _unhandled_input(event: InputEvent) -> void:
	# If attempting to access a slot with a numbered input
	if event is InputEventKey && event.keycode >= KEY_1 && event.keycode <= KEY_9 && event.is_action_pressed("access_hotbar_slot"):
		var lowest_val = KEY_1
		var greatest_val = lowest_val + len(slots)
		
		# If input outside current number of slots
		if event.keycode >= greatest_val or event.keycode < lowest_val:
			return
		
		# Change slot to inputted slot
		slots[current_slot].UnequipSlot()
		current_slot = event.keycode - lowest_val
		slots[current_slot].EquipSlot()
		FocusSlots()
	
	elif event.is_action_pressed("previous_hotbar_slot"):
		slots[current_slot].UnequipSlot()
		current_slot = abs((current_slot - 1) % len(slots))
		slots[current_slot].EquipSlot()
		FocusSlots()
		
	elif event.is_action_pressed("next_hotbar_slot"):
		slots[current_slot].UnequipSlot()
		current_slot = (current_slot + 1) % len(slots)
		slots[current_slot].EquipSlot()
		FocusSlots()
		
	elif event.is_action_pressed("next_item_in_slot"):
		if slots[current_slot] is EquipmentSlot:
			slots[current_slot].ChangeToNextItem()

	elif event.is_action_pressed("previous_item_in_slot"):
		if slots[current_slot] is EquipmentSlot:
			slots[current_slot].ChangeToPreviousItem()
			
func FocusSlots() -> void:
	# Change theme of slot depending on whether it is the currently selected slot
	for i in range(slots.size()):
		if i == current_slot:
			slots[i].add_theme_stylebox_override("panel", slots[i].theme.get_stylebox("selected", "ToolPanel"))
			slots[i].EquipSlot()
		else:
			slots[i].add_theme_stylebox_override("panel", slots[i].theme.get_stylebox("normal", "ToolPanel"))
			slots[i].UnequipSlot()

func DisplayItems() -> void:
	for item in HotbarManager.hotbar_inventory_slots:
		if item not in inventory_slots.keys():
			# Create slot
			var new_slot: InventorySlot = inventory_slot_framework.instantiate() as InventorySlot
			
			# Set its display settings
			new_slot.AssignItem(item)
			new_slot.AssignIcon(NameTextureDictionary.texture_dictionary.get(item))
			new_slot.AssignAmountLabel()
				
			# Assign it to its node path and array reference
			slot_container.add_child(new_slot)
			inventory_slots[item] = new_slot
			slots.append(new_slot)
	
	for slot in inventory_slots.keys():
		if slot not in HotbarManager.hotbar_inventory_slots:
			# Delete slot
			inventory_slots[slot].queue_free()
			inventory_slots.erase(slot)
