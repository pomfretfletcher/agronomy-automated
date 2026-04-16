class_name StorageInventoryInteractionComponent
extends InventoryInteractionComponent


# Information
# Use - External
# By - Connected to signal of opened interfaces
# For - Calls internal method
# Explanation -
#	If passed data, call internal method
func DoFullStackInteraction(data: Dictionary) -> void:
	# For interactions between the inventory and another interface
	if (data["from"] is StorageSlot or data["to"] is StorageSlot) and (data["to"] is InventorySlot or data["from"] is InventorySlot):
		FullStackInteraction(data)


# Information - OOD
# Use - Internal
# By - DoFullStackInteraction
# For - Moving of all of an item from inventory to storage or vice verca
# Explanation -
#	Stores given variables in more readable and usable versions
#	If storage to inventory:
#		If slot item dragged into is empty:
#			If existing item, update content amounts and slot labels
#			If new item, add to contents and setup inventory slot with 
#				dragged item
#			Remove item from storage and slots
#		If slot item dragged into is not empty:
#			If existing dragged item, update content amounts and slot labels
#			If new dragged item, add to contents and place in inventory slot
#				Swapped item equal to item that was in inventory slot
#				Then if swapped item existing in storage, update contents/slots
#				If swapped item new, add to storage contents and from slot
#			Remove dragged item from storage and slots
#	If inventory to storage:
#		If slot item dragged into is empty:
#			If existing item, update content amounts and slot labels
#			If new item, add to contents and setup storage slot with 
#				dragged item
#			Remove item from inventory and slots
#		If slot item dragged into is not empty:
#			If existing dragged item, update content amounts and slot labels
#			If new dragged item, add to contents and place in storage slot
#				Swapped item equal to item that was in storage slot
#				Then if swapped item existing in inventory, update contents/slots
#				If swapped item new, add to storage contents and from slot
#			Remove dragged item from storage and slots
func FullStackInteraction(data: Dictionary) -> void:
	var used_inventory_slot: InventorySlot = data["from"] if data["from"] is InventorySlot else data["to"]
	var used_storage_slot: StorageSlot = data["from"] if data["from"] is StorageSlot else data["to"]
	
	var inventory_to_storage: bool = (used_inventory_slot == data["from"])
	var storage_to_inventory: bool = (used_inventory_slot == data["to"])
	
	# No interaction if both empty
	if used_inventory_slot.item_name == "" and used_storage_slot.item_name == "":
		return
	
	if storage_to_inventory: 
		FullStackInteractionFromStorage(data)
	elif inventory_to_storage:
		FullStackInteractionFromInventory(data)


func FullStackInteractionFromInventory(data: Dictionary) -> void:
	var from_slot: InventorySlot = data["from"]
	var to_slot: StorageSlot = data["to"]
	
	var moved_item = {
		"name": from_slot.item_name,
		"amount": from_slot.amount,
	}
	var swapped_item = {
		"name": to_slot.item_name,
		"amount": to_slot.amount,
	}
	
	if to_slot.is_empty:
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
	else:
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
			RemoveFromStorage(swapped_item["name"])
			SetupStorageSlot(moved_item["name"], to_slot)
			if swapped_item["name"] in inventory_interface.slot_item_assignment_component.current_contents:
				UpdateInventoryAmounts(swapped_item["name"], swapped_item["amount"])
				UpdateInventorySlotAmounts(swapped_item["name"])
				ClearInventorySlot(from_slot)
			else:
				AddToInventory(swapped_item["name"], swapped_item["amount"])
				SetupInventorySlot(swapped_item["name"], from_slot)


func FullStackInteractionFromStorage(data: Dictionary) -> void:
	var from_slot: StorageSlot = data["from"]
	var to_slot: InventorySlot = data["to"]
	
	var moved_item = {
		"name": from_slot.item_name,
		"amount": from_slot.amount,
	}
	var swapped_item = {
		"name": to_slot.item_name,
		"amount": to_slot.amount,
	}
	
	if to_slot.is_empty:
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
	else:
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
			RemoveFromInventory(swapped_item["name"])
			SetupInventorySlot(moved_item["name"], to_slot)
			if swapped_item["name"] in interacting_interface.slot_item_assignment_component.current_contents:
				UpdateStorageAmounts(swapped_item["name"], swapped_item["amount"])
				UpdateStorageSlotAmounts(swapped_item["name"])
				ClearStorageSlot(from_slot)
			else:
				AddToStorage(swapped_item["name"], swapped_item["amount"])
				SetupStorageSlot(swapped_item["name"], from_slot)


# Information
# Use - External
# By - Connected to signal of opened interfaces
# For - Calls internal method
# Explanation -
#	If passed data, call internal method
func DoSingleItemInteraction(data: Dictionary) -> void:
	if data["from"] != null:
		SingleItemInteraction(data)


# Information
# Use - Internal
# By - DoSingleItemInteraction
# For - Calls appropiate single item interaction method
# Explanation -
#	Calls from inventory method if passed data's type is inventory slot
#	Calls from storage method is passed data's type is storage slot
func SingleItemInteraction(data: Dictionary) -> void:
	if data["from"] is InventorySlot:
		SingleItemInteractionFromInventory(data["from"])
	elif data["from"] is StorageSlot:
		SingleItemInteractionFromStorage(data["from"])


# Information
# Use - Internal
# By - SingleItemInteraction
# For - Moving single items from inventory interface to storage interface
# Explanation -
#	Add one of item to storage interface (If space)
#	If no space, return and stop interaction
#	Reduces amount of item by one in inventory interface
#	If last of item removed from inventory, delete reference from inventory
# Debug - Optional print statements:
#	No space remaining in storage
func SingleItemInteractionFromInventory(from_slot: InventorySlot) -> void:
	var sent_item: String = from_slot.item_name
	
	var storageslotcomp = interacting_interface.slot_item_assignment_component
	if sent_item in storageslotcomp.current_contents.keys():
		UpdateStorageAmounts(sent_item, 1)
		UpdateStorageSlotAmounts(sent_item)
		RemoveOneFromInventory(sent_item)
		UpdateInventoryOrHotbarSlotAmounts(from_slot, sent_item)
		
	elif sent_item not in storageslotcomp.current_contents.keys():
		# Find first empty storage slot
		var to_slot: StorageSlot = FindFirstEmptySlot("storage")
		
		if to_slot:
			AddToStorage(sent_item, 1)
			SetupStorageSlot(sent_item, to_slot)
			RemoveOneFromInventory(sent_item)
			UpdateInventoryOrHotbarSlotAmounts(from_slot, sent_item)
		if to_slot == null:
			print("No remaining slots in storage to move item into.")
		
	# If none left in inventory, remove item from inventory contents and slots
	var inventoryslotcomp = inventory_interface.slot_item_assignment_component
	if inventoryslotcomp.current_contents[sent_item] == 0:
		RemoveFromInventory(sent_item)
		ClearInventorySlot(from_slot)


# Information
# Use - Internal
# By - SingleItemInteraction
# For - Moving single items from storage interface to inventory interface
# Explanation -
#	Add one of item to inventory interface (If space)
#	If no space, return and stop interaction
#	Takes currency based on sell value
#	Reduces amount of item by one in storage interface
#	If last of item removed from storage, delete reference from storage
# Debug - Optional print statements:
#	No space remaining in inventory
func SingleItemInteractionFromStorage(from_slot: StorageSlot) -> void:
	var sent_item: String = from_slot.item_name
	
	var inventoryslotcomp = inventory_interface.slot_item_assignment_component
	if sent_item in inventoryslotcomp.current_contents.keys():
		UpdateInventoryAmounts(sent_item, 1)
		UpdateInventorySlotAmounts(sent_item)
		RemoveOneFromStorage(sent_item)
		UpdateStorageSlotAmounts(sent_item)
		
	elif sent_item not in inventoryslotcomp.current_contents.keys():
		# Find first empty inventory slot
		var to_slot: InventorySlot = FindFirstEmptySlot("inventory")
		
		if to_slot:
			AddToInventory(sent_item, 1)
			SetupInventorySlot(sent_item, to_slot)
			RemoveOneFromStorage(sent_item)
			UpdateStorageSlotAmounts(sent_item)
		if to_slot == null:
			print("No remaining slots in inventory to move item into.")
		
	# If none left in inventory, remove item from inventory contents and slots
	var storageslotcomp = interacting_interface.slot_item_assignment_component
	if storageslotcomp.current_contents[sent_item] == 0:
		RemoveFromStorage(sent_item)
		ClearStorageSlot(from_slot)


# Information
# Use - Internal
# By - SingleItemInteractionFromStorage
# For - Reduces amount of given item by one in storage interface
# Explanation -
#	If item in contents, reduce stored amount
#	If item not in contents, print error, print current contents
# Debug - Error print statements:
#	Item not present in contents
func RemoveOneFromStorage(item_name: String) -> void:
	var islotcomp = interacting_interface.slot_item_assignment_component
	if item_name in islotcomp.current_contents.keys():
		#print("There are currently " + str(islotcomp.current_contents[item_name]) + " " + item_name + " in storage contents.")
		islotcomp.current_contents[item_name] -= 1
		#print("There are now " + str(islotcomp.current_contents[item_name]) + " " + item_name + " in storage contents.")
	else:
		print("Error removing " + item_name + " from storage contents. It is not present.")


# Information
# Use - Internal
# By - FullStackInteraction, SingleItemInteractionFromInventory
# For - Adds a new shop item to the storage contents
# Explanation -
#	If item in contents, print error and return
#	Create entry for item in shop contents
#	Set entry amount to given amount
# Debug - Error print statements:
#	Item already present in contents
# Debug - Optional print statements:
#	Amount of item added
func AddToStorage(item_name: String, amount: int) -> void:
	var islotcomp = interacting_interface.slot_item_assignment_component
	if islotcomp.current_contents.has(item_name):
		print("Error adding new " + item_name + " to storage, it is already present.")
	else:
		islotcomp.current_contents[item_name] = amount
		#print("There is now " + str(islotcomp.current_contents[item_name]) + " " + item_name + " in the storage contents.")


# Information
# Use - Internal
# By - FullStackInteraction, SingleItemInteractionFromStorage
# For - Removes all stored amounts of the given item from the storage interface
# Explanation -
#	If item in contents, erase dictionary entry
#	If item not in contents, print error, print current contents
# Debug - Error print statements:
#	Item not present in contents
func RemoveFromStorage(item_name: String) -> void:
	var islotcomp = interacting_interface.slot_item_assignment_component
	if islotcomp.current_contents.has(item_name):
		islotcomp.current_contents.erase(item_name)
		#print(item_name + " removed from storage contents.")
	else:
		print("Error removing " + item_name + " from storage, it is not present.")
		print("Current storage contents: " + str(islotcomp.current_contents))


# Information
# Use - Internal
# By - FullStackInteraction, SingleItemInteractionFromInventory
# For - Gives the given slot a reference to an item
# Explanation -
#	Uses slot's set item method to have it be a reference to the given item
func SetupStorageSlot(item_name: String, slot: StorageSlot) -> void:
	slot.SetItem(item_name)


# Information
# Use - Internal
# By - FullStackInteraction, SingleItemInteractionFromStorage
# For - Removes the reference to its item from the given slot
# Explanation -
#	Use slot's remove item method to remove the stored item and amount from slot
func ClearStorageSlot(slot: StorageSlot) -> void:
	slot.RemoveItem()


# Information
# Use - Internal
# By - FullStackInteraction, SingleItemInteractionFromInventory, SingleItemInteractionFromStorage
# For - Adds a new storage item to the storage contents
# Explanation -
#	If item in contents, increase amount of entry by given amount
#	If item not in contents, print error
# Debug - Error print statements:
#	Item not present in contents
# Debug - Optional print statements:
#	Amount of item before
#	Amount of item after
func UpdateStorageAmounts(item_name: String, amount_added: int) -> void:
	var islotcomp = interacting_interface.slot_item_assignment_component
	if item_name in islotcomp.current_contents:
		#print("There is currently " + str(islotcomp.current_contents[item_name]) + item_name + " in the storage contents.")
		islotcomp.current_contents[item_name] += amount_added
		#print("There is now " + str(islotcomp.current_contents[item_name]) + item_name + " in the storage contents.")
	else:
		print("Attempt to add to an existing storage slot failed, " + item_name + " not present in storage contents.")


# Information
# Use - Internal
# By - FullStackInteraction, SingleItemInteractionFromInventory
# For - Updates the label showcasing the amount of the given item on the
#		slot referencing it
# Explanation -
#	Finds slot referencing item
#	Uses slot's update amount label method to update its label
# Debug - Error print statements
#	No slot referencing item
func UpdateStorageSlotAmounts(item_name: String) -> void:
	var slot = FindSlotWithItem("storage", item_name)
	slot.UpdateAmountLabel(item_name)
	
	if not slot == null:
		print("Error finding " + item_name + " in storage slots.")
