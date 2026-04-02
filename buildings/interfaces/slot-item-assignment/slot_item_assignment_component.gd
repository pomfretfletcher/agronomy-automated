class_name SlotItemAssignmentComponent
extends Node

var current_contents: Dictionary[String, int]
var current_slots: Array[Array]
@export var interface: Interface

func FindSlotWithItem(item_name: String) -> InterfaceSlot:
	for row in current_slots:
		for slot in row:
			var cur_slot = slot as InterfaceSlot
			if cur_slot.item_name == item_name:
				return cur_slot
	return null

func FindFirstEmptySlot() -> InterfaceSlot:
	for row in current_slots:
		for slot in row:
			var cur_slot = slot as InterfaceSlot
			if cur_slot.is_empty:
				return cur_slot
	return null
