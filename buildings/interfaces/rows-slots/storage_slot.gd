class_name StorageSlot
extends InterfaceSlot

# Function Information
# Use - Interface Use, Item Shopping
# Does - Gets amount of its item in its interface, then sets it as its amount label
# Debug - Error statement
#		Item name not present in interface
func AssignAmountLabel() -> void:
	amount = slot_item_assignment_component.current_contents.get(item_name)
	super()

# Function Information
# Use - Interface Use, Item Shopping
# Does - Handles dragging around item stacks inside own interface or emits signal with data
# Debug - N/A
func _drop_data(_at_position, data):
	var from_slot = data["from"] as InterfaceSlot
	var dragged_item = data["item"] as String
	var temp = item_name
	
	if interface != from_slot.interface and interface.being_used_in_interface_interaction:
		data["to"] = self
		interface.full_stack_movement.emit(data)
		
	if from_slot == self:
		return
	
	if interface == from_slot.interface:
		# Sets up new data in this slot
		if dragged_item != "":
			SetItem(dragged_item)
			if from_slot.price != 0:
				UpdatePriceLabel(from_slot.price)
		
		# Changes data in previous slot
		if temp != "":
			from_slot.SetItem(temp)
			if price != 0:
				from_slot.UpdatePriceLabel(price)
		else:
			from_slot.RemoveItem()

	from_slot.RemoveFocusFromSlot()
