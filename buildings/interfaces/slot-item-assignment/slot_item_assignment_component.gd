class_name SlotItemAssignmentComponent
extends Node

var current_contents: Dictionary[String, int]
var current_slots: Array[Array]
@export var interface: Interface

# Function Information
# Use - Interface Use
# Does - Return the slot within the interface that has the given item
# Debug - N/A
func FindSlotWithItem(item_name: String) -> InterfaceSlot:
	for row in current_slots:
		for slot in row:
			var cur_slot = slot as InterfaceSlot
			if cur_slot.item_name == item_name:
				return cur_slot
	return null

# Function Information
# Use - Interface Use
# Does - Find the first slot in the interface with no reference item
# Debug - N/A
func FindFirstEmptySlot() -> InterfaceSlot:
	for row in current_slots:
		for slot in row:
			var cur_slot = slot as InterfaceSlot
			if cur_slot.is_empty:
				return cur_slot
	return null
