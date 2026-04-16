class_name InventorySlot
extends InterfaceSlot


func _ready() -> void:
	super()
	InventoryManager.inventory_changed.connect(UpdateAmountLabel)


# Function Information
# Use - Interface Use, Inventory
# Does - Gets amount of its item in the inventory, then sets it as its amount label
# Debug - Error statement
#		Item name not present in inventory
func AssignAmountLabel() -> void:
	amount = InventoryManager.inventory.get(item_name)
	super()


# Function Information
# Use - Interface Use, Inventory
# Does - Handles dragging around item stacks inside own interface or emits signal with data
func _drop_data(_at_position, data):
	var from_slot = data["from"]
	var dragged_item = data["item"]
	var temp = item_name
	
	# Allow regular dragging between hotbar and inventory
	if (interface != from_slot.interface 
		and interface.being_used_in_interface_interaction 
		and from_slot.interface is not HotbarInterface): 
			data["to"] = self
			interface.full_stack_movement.emit(data)
		
	if from_slot == self:
		return
	
	if interface == from_slot.interface or (from_slot is HotbarSlot and self is InventorySlot) or (from_slot is InventorySlot and self is HotbarSlot):
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
