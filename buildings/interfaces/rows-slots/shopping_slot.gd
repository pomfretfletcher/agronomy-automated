## A slot used in the creation and use of a shopping building's interface.
class_name ShoppingSlot
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
# Does - Emits signal that an item stack is dragged with data
func _drop_data(_at_position, data) -> void:
	var from_slot = data["from"]
	
	if interface != from_slot.interface and interface.being_used_in_interface_interaction:
		data["to"] = self
		interface.full_stack_movement.emit(data)
	
	# Return from slot to previous look
	from_slot.RemoveFocusFromSlot()
