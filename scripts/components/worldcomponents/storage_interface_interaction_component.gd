class_name StorageInterfaceInteractionComponent
extends Node2D

@export var inventory_interface: InventoryInterface
var interacting_interface: StorageInterface

func OpenInterfaces(using_interface: StorageInterface) -> void:
	interacting_interface = using_interface
	ToggleInterfaceMode(inventory_interface, "open")
	ToggleInterfaceMode(interacting_interface, "open")

func CloseInterfaces() -> void:
	ToggleInterfaceMode(inventory_interface, "close")
	ToggleInterfaceMode(interacting_interface, "close")

func ToggleInterfaceMode(interface: Interface, mode: String) -> void:
	if mode == "open":
		interface.OpenInterface()
		interface.lock_open_close = true
		interface.being_used_in_interface_interaction = true
		interface.drop_data_occuring.connect(DoInterfaceInteraction)
	if mode == "close":
		interface.CloseInterface()
		interface.lock_open_close = false
		interface.being_used_in_interface_interaction = false
		interface.drop_data_occuring.disconnect(DoInterfaceInteraction)

func DoInterfaceInteraction(data: Dictionary) -> void:
	# For interactions between the inventory and another interface
	if data["from"] is StorageSlot or data["to"] is StorageSlot:
		StorageInteraction(data)

func StorageInteraction(data: Dictionary):
	var used_inventory_slot: InventorySlot = data["from"] if data["from"] is InventorySlot else data["to"]
	var used_storage_slot: StorageSlot = data["from"] if data["from"] is StorageSlot else data["to"]
	
	var inventory_to_storage: bool = (used_inventory_slot == data["from"])
	var storage_to_inventory: bool = (used_inventory_slot == data["to"])
	
	var from_slot: Slot = used_inventory_slot if inventory_to_storage else used_storage_slot
	var to_slot: Slot = used_inventory_slot if storage_to_inventory else used_storage_slot
	
	var moved_item = {
		"name": from_slot.item_name,
		"amount": from_slot.amount,
		"origin_slot": from_slot,
		"end_slot": to_slot
	}
	var swapped_item = {
		"name": to_slot.item_name,
		"amount": to_slot.amount,
		"origin_slot": to_slot,
		"end_slot": from_slot
	}
		
	# No interaction if both empty
	if used_inventory_slot.item_name == "" and used_storage_slot.item_name == "":
		return
	
	# Storage item into empty inventory slot
	if to_slot.is_empty and storage_to_inventory:
		if moved_item["name"] in InventoryManager.inventory.keys():
			# Add to existing slot within the inventory interface
			UpdateInventoryAmounts(moved_item["name"], moved_item["amount"])
			UpdateInventorySlotAmounts(moved_item["name"])
			RemoveFromStorage(moved_item["name"])
			ClearStorageSlot(from_slot)
		else:
			# Add to the new slot within the inventory interface
			AddToInventory(moved_item["name"], moved_item["amount"])
			SetupInventorySlot(moved_item["name"], to_slot)
			RemoveFromStorage(moved_item["name"])
			ClearStorageSlot(from_slot)
	
	# Storage item into non-empty inventory slot
	elif !to_slot.is_empty and storage_to_inventory:
		if moved_item["name"] in InventoryManager.inventory.keys():
			# Add to existing slot within the inventory interface, place item from
			# inventory into storage
			UpdateInventoryAmounts(moved_item["name"], moved_item["amount"])
			UpdateInventorySlotAmounts(moved_item["name"])
			RemoveFromStorage(moved_item["name"])
			ClearStorageSlot(from_slot)
		else:
			# Place item from storage into inventory slot, place item from
			# inventory into storage
			AddToInventory(moved_item["name"], moved_item["amount"])
			RemoveFromStorage(moved_item["name"])
			AddToStorage(swapped_item["name"], swapped_item["amount"])
			RemoveFromInventory(swapped_item["name"])
			SetupInventorySlot(moved_item["name"], to_slot)
			SetupStorageSlot(swapped_item["name"], from_slot)
	
	# Inventory item into empty storage slot
	elif to_slot.is_empty and inventory_to_storage:
		if moved_item["name"] in interacting_interface.slot_item_assignment_component.current_contents:
			# Add to existing slot within the storage interface
			UpdateStorageAmounts(moved_item["name"], moved_item["amount"])
			UpdateStorageSlotAmounts(moved_item["name"])
			RemoveFromInventory(moved_item["name"])
			ClearInventorySlot(from_slot)
		else:
			# Add to the new slot within the storage interface 
			AddToStorage(moved_item["name"], moved_item["amount"])
			SetupStorageSlot(moved_item["name"], to_slot)
			RemoveFromInventory(moved_item["name"])
			ClearInventorySlot(from_slot)
			
	# Inventory item into non empty storage slot
	elif !to_slot.is_empty and inventory_to_storage:
		if moved_item["name"] in interacting_interface.slot_item_assignment_component.current_contents:
			# Add to existing slot within the storage interface, place item from
			# storage into inventory
			UpdateStorageAmounts(moved_item["name"], moved_item["amount"])
			UpdateStorageSlotAmounts(moved_item["name"])
			RemoveFromInventory(moved_item["name"])
			ClearInventorySlot(from_slot)
		else:
			# Place item from inventory into storage slot, place item from
			# storage into inventory
			AddToStorage(moved_item["name"], moved_item["amount"])
			RemoveFromInventory(moved_item["name"])
			AddToInventory(swapped_item["name"], swapped_item["amount"])
			RemoveFromStorage(swapped_item["name"])
			SetupStorageSlot(moved_item["name"], to_slot)
			SetupInventorySlot(swapped_item["name"], from_slot)

func AddToInventory(item_name: String, amount: int) -> void:
	var islotcomp = inventory_interface.slot_item_assignment_component
	if islotcomp.current_contents.has(item_name):
		print("Error adding new " + item_name + " to inventory, it is already present.")
	else:
		# Adds without signal so we can deal with slot logic in this script itself
		InventoryManager.AddItemToInventoryWithoutSignal(item_name, amount)
		islotcomp.current_contents[item_name] = amount
		print("There is now " + str(islotcomp.current_contents[item_name]) + " " + item_name + " in the inventory interface contents.")
		print("There is now " + str(InventoryManager.inventory[item_name]) + " " + item_name + " in the inventory.")

func AddToStorage(item_name: String, amount: int) -> void:
	var islotcomp = interacting_interface.slot_item_assignment_component
	if islotcomp.current_contents.has(item_name):
		print("Error adding new " + item_name + " to storage, it is already present.")
	else:
		islotcomp.current_contents[item_name] = amount
		print("There is now " + str(islotcomp.current_contents[item_name]) + " " + item_name + " in the storage contents.")

func RemoveFromInventory(item_name: String) -> void:
	var islotcomp = inventory_interface.slot_item_assignment_component
	if islotcomp.current_contents.has(item_name) and InventoryManager.inventory.has(item_name):
		# Removes without signal so we can deal with slot logic in this script itself
		InventoryManager.RemoveItemFromInventoryWithoutSignal(item_name)
		islotcomp.current_contents.erase(item_name)
		print(item_name + " removed from inventory and inventory interface contents.")
	else:
		print("Error removing " + item_name + " from inventory or inventory interface contents, it is not present.")
		print("Current inventory: " + str(InventoryManager.inventory))
		print("Current inventory interface contents: " + str(islotcomp.current_contents))
		
func RemoveFromStorage(item_name: String) -> void:
	var islotcomp = interacting_interface.slot_item_assignment_component
	if islotcomp.current_contents.has(item_name):
		islotcomp.current_contents.erase(item_name)
		print(item_name + " removed from storage contents.")
	else:
		print("Error removing " + item_name + " from storage, it is not present.")
		print("Current storage contents: " + str(islotcomp.current_contents))
		
func SetupInventorySlot(item_name: String, slot: InventorySlot) -> void:
	slot.SetItem(item_name, NameTextureDictionary.texture_dictionary.get(item_name))

func SetupStorageSlot(item_name: String, slot: StorageSlot) -> void:
	slot.SetItem(item_name, NameTextureDictionary.texture_dictionary.get(item_name))

func ClearInventorySlot(slot: InventorySlot) -> void:
	slot.RemoveItem()

func ClearStorageSlot(slot: StorageSlot) -> void:
	slot.RemoveItem()

func UpdateInventoryAmounts(item_name: String, amount_added: int) -> void:
	var islotcomp = inventory_interface.slot_item_assignment_component
	if item_name in islotcomp.current_contents:
		print("There is currently " + str(islotcomp.current_contents[item_name]) + item_name + " in the inventory interface contents.")
		print("There is currently " + str(InventoryManager.inventory[item_name]) + item_name + " in the inventory.")
		InventoryManager.AddItemToInventoryWithoutSignal(item_name, amount_added)
		islotcomp.current_contents[item_name] += amount_added
		print("There is now " + str(islotcomp.current_contents[item_name]) + item_name + " in the inventory interface contents.")
		print("There is now " + str(InventoryManager.inventory[item_name]) + item_name + " in the inventory.")
	else:
		print("Attempt to add to an existing inventory slot failed, " + item_name + " not present in inventory.")

func UpdateStorageAmounts(item_name: String, amount_added: int) -> void:
	var islotcomp = interacting_interface.slot_item_assignment_component
	if item_name in islotcomp.current_contents:
		print("There is currently " + str(islotcomp.current_contents[item_name]) + item_name + " in the storage contents.")
		islotcomp.current_contents[item_name] += amount_added
		print("There is now " + str(islotcomp.current_contents[item_name]) + item_name + " in the storage contents.")
	else:
		print("Attempt to add to an existing storage slot failed, " + item_name + " not present in storage contents.")

func UpdateInventorySlotAmounts(item_name: String) -> void:
	var islotcomp = inventory_interface.slot_item_assignment_component as InventorySlotItemAssignmentComponent
	
	var found = false
	for row in islotcomp.current_slots:
		for slot in row:
			var cur_slot = slot as InventorySlot
			if cur_slot.item_name == item_name:
				cur_slot.AssignAmountLabel()
				found = true
	
	if !found:
		print("Error finding " + item_name + " in inventory slots.")

func UpdateStorageSlotAmounts(item_name: String) -> void:
	var islotcomp = interacting_interface.slot_item_assignment_component as StorageSlotItemAssignmentComponent
	
	var found = false
	for row in islotcomp.current_slots:
		for slot in row:
			var cur_slot = slot as StorageSlot
			if cur_slot.item_name == item_name:
				cur_slot.AssignAmountLabel()
				found = true
	
	if !found:
		print("Error finding " + item_name + " in inventory slots.")
	
#func RemoveFromStorage(data: Dictionary) -> void:
	#var islotcomp: StorageSlotItemAssignmentComponent = interacting_interface.slot_item_assignment_component
	#islotcomp.current_contents.erase(data["name"])
	#
	#for row in islotcomp.current_slots:
		#for slot in row:
			#var cur_slot = slot as StorageSlot
			#if cur_slot.item_name == data["name"]:
				#cur_slot.RemoveItem()
#
#func RemoveFromInventory(data: Dictionary) -> void:
	#InventoryManager.RemoveItemFromInventoryWithoutSignal(data["name"])
	#
	#var islotcomp: InventorySlotItemAssignmentComponent = inventory_interface.slot_item_assignment_component
	#islotcomp.current_contents.erase(data["name"])
	#
	#for row in islotcomp.current_slots:
		#for slot in row:
			#var cur_slot = slot as InventorySlot
			#if cur_slot.item_name == data["name"]:
				#cur_slot.RemoveItem()
#
#func AddToNewInventorySlot(data: Dictionary) -> void:
	## Add to contents first. This means that when inventory changed signal is called,
	## the slot assignment component does not assign the item to the first slot
	#var islotcomp: InventorySlotItemAssignmentComponent = inventory_interface.slot_item_assignment_component
	#islotcomp.current_contents[data["name"]] = data["amount"]
#
	## Then assigns the slot with the values passed
	#var slot: InventorySlot = data["end_slot"]
	#slot.SetItem(data["name"], NameTextureDictionary.texture_dictionary.get(data["name"]))
#
#func AddToNewStorageSlot(data: Dictionary) -> void:
	#var islotcomp: StorageSlotItemAssignmentComponent = interacting_interface.slot_item_assignment_component
	#islotcomp.current_contents[data["name"]] = data["amount"]
	#
	#var slot: StorageSlot = data["end_slot"]
	#slot.SetItem(data["name"], NameTextureDictionary.texture_dictionary.get(data["name"]))
#
#func AddToExistingInventorySlot(data: Dictionary) -> void:
	#print(data)
	#InventoryManager.AddItemToInventoryWithoutSignal(data["name"], data["amount"])
	#
	#var islotcomp: InventorySlotItemAssignmentComponent = inventory_interface.slot_item_assignment_component
	#
	#for row in islotcomp.current_slots:
		#for slot in row:
			#var cur_slot = slot as InventorySlot
			#if cur_slot.item_name == data["name"]:
				#cur_slot.AssignAmountLabel()
	#
#func AddToExistingStorageSlot(data: Dictionary) -> void:
	#var islotcomp: StorageSlotItemAssignmentComponent = interacting_interface.slot_item_assignment_component
	#
	#for row in islotcomp.current_slots:
		#for slot in row:
			#var cur_slot = slot as StorageSlot
			#if cur_slot.item_name == data["name"]:
				#cur_slot.AssignAmountLabel()
