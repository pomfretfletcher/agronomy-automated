class_name StorageSlotItemAssignmentComponent
extends SlotItemAssignmentComponent

func UpdateSlots(item_changed: String) -> void:
	if item_changed not in current_contents.keys():
		RemoveItemFromSlots(item_changed)

func RemoveItemFromSlots(item: String) -> void:
	if item not in current_contents.keys():
		return
		
	for row in current_slots:
		for slot in row:
			if slot.item_name == item:
				slot.RemoveItem()
