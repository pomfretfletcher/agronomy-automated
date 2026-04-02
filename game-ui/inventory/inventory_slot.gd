class_name InventorySlot
extends InterfaceSlot

func _ready() -> void:
	super()
	InventoryManager.inventory_changed.connect(UpdateAmountLabel)

func AssignAmountLabel() -> void:
	amount = slot_item_assignment_component.current_contents[item_name]
	super()

@warning_ignore("unused_parameter")
func _drop_data(at_position, data):
	var from_slot = data["from"]
	var dragged_item = data["item"]
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
		
		# Changes data in previous slot
		if temp != "":
			from_slot.SetItem(temp)
		else:
			from_slot.RemoveItem()

	from_slot.RemoveFocusFromSlot()
