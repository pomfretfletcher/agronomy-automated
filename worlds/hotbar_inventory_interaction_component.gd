class_name HotbarInventoryInteractionComponent
extends InventoryInteractionComponent


@warning_ignore("unused_parameter")
func OpenInterfaces(using_interface: Interface) -> void:
	ToggleHotbarInterfaceMode("open")
	ToggleInterfaceMode(inventory_interface, "open")


func CloseInterfaces() -> void:
	ToggleHotbarInterfaceMode("close")
	ToggleInterfaceMode(inventory_interface, "close")


func ToggleInterfaceMode(interface: Interface, mode: String) -> void:
	if mode == "open":
		interface.OpenInterface()
		interface.being_used_in_interface_interaction = true
		interface.full_stack_movement.connect(DoFullStackInteraction)
		interface.single_item_movement.connect(DoSingleItemInteraction)
	if mode == "close":
		interface.CloseInterface()
		interface.being_used_in_interface_interaction = false
		interface.full_stack_movement.disconnect(DoFullStackInteraction)
		interface.single_item_movement.disconnect(DoSingleItemInteraction)


func DoSingleItemInteraction(data: Dictionary) -> void:
	if data["from"] != null:
		SingleItemInteraction(data)


func SingleItemInteraction(data: Dictionary) -> void:
	if data["from"] is HotbarSlot:
		SingleItemInteractionFromHotbar(data["from"])
	elif data["from"] is InventorySlot:
		SingleItemInteractionFromInventory(data["from"])


func SingleItemInteractionFromHotbar(from_slot: HotbarSlot) -> void:
	var sent_item: String = from_slot.item_name
	
	var to_slot: InventorySlot = FindFirstEmptySlot("inventory")
	if to_slot:
		SetupInventorySlot(sent_item, to_slot)
		ClearInventorySlot(from_slot)
	else:
		print("No space to move item from hotbar into inventory.")


func SingleItemInteractionFromInventory(from_slot: InventorySlot) -> void:
	var sent_item: String = from_slot.item_name
	
	var to_slot: HotbarSlot = FindFirstEmptyHotbarSlot()
	if to_slot:
		SetupInventorySlot(sent_item, to_slot)
		ClearInventorySlot(from_slot)
	else:
		print("No space to move item from inventory into hotbar.")
