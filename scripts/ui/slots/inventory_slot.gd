class_name InventorySlot
extends InterfaceSlot

func _ready() -> void:
	super._ready()
	InventoryManager.inventory_changed.connect(UpdateAmountLabel)

func UpdateAmountLabel(item_changed: String) -> void:
	if item_changed != item_name:
		return
	else:
		AssignAmountLabel()

func AssignAmountLabel() -> void:
	amount = InventoryManager.inventory[item_name]
	super.AssignAmountLabel()

func _drop_data(_at_position, data):
	var from_slot = data["from"]
	var dragged_item = data["item"]
	var temp = item_name
	
	if interface != from_slot.interface and interface.being_used_in_interface_interaction:
		data["to"] = self
		interface.drop_data_occuring.emit(data)
		
	if from_slot == self:
		return
	
	if interface == from_slot.interface:
		# Sets up new data in this slot
		if dragged_item != "":
			SetItem(dragged_item, NameTextureDictionary.texture_dictionary.get(dragged_item))
		
		# Changes data in previous slot
		if temp != "":
			from_slot.SetItem(temp, NameTextureDictionary.texture_dictionary.get(temp))
		else:
			from_slot.RemoveItem()

	from_slot.RemoveFocusFromSlot()
