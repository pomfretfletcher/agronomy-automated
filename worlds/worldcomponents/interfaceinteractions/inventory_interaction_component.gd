class_name InventoryInteractionComponent
extends Node2D

@export var inventory_interface: InventoryInterface
var interacting_interface: Interface

# Information
# Use - Internal by Child Classes
# By - Child Classes - SingleItemInteractionFromInventory, SingleItemInteractionFromShop, SingleItemInteractionFromStorage
# For - Returns the first empty slot that contains no reference item
# Explanation -
#	Decides interface based on given string. If "inventory" will do inventory
#		interface, any other value will do the interacting interface
#	Loops through each slot in current slots until find the slot with no stored
#		name being the given name
#	If it finds a slot, returns the slot
#	If no slot found, returns null
# Debug - N/A
func FindFirstEmptySlot(searching_interface: String) -> InterfaceSlot:
	var interface = inventory_interface if searching_interface == "inventory" else interacting_interface
	var islotcomp = interface.slot_item_assignment_component
	for row in islotcomp.current_slots:
		for slot in row:
			var cur_slot = slot as InterfaceSlot
			if cur_slot.is_empty:
				return cur_slot
	return null

# Information
# Use - Internal by Child Classes
# By - UpdateInventorySlotAmounts
# By - Child Classes - UpdateShopSlotAmounts, UpdateStorageSlotAmounts
# For - Returns the slot that contains the reference to the given item within
#		the given interface
# Explanation -
#	Decides interface based on given string. If "inventory" will do inventory
#		interface, any other value will do the interacting interface
#	Loops through each slot in current slots until find the slot with the stored
#		name being the given name
#	If it finds the slot, returns the slot
#	If slot not found, returns null
# Debug - N/A
func FindSlotWithItem(searching_interface: String, item_name: String) -> InterfaceSlot:
	var interface = inventory_interface if searching_interface == "inventory" else interacting_interface
	var islotcomp = interface.slot_item_assignment_component
	for row in islotcomp.current_slots:
		for slot in row:
			var cur_slot = slot as InterfaceSlot
			if cur_slot.item_name == item_name:
				return cur_slot
	return null

# Information
# Use - External
# By - Attached object of interacting interface
# For - Creates interface interaction between inventory and given interface
# Explanation -
#	Sets inventory and the interacting interface into open modes
# Debug - N/A
func OpenInterfaces(using_interface: Interface) -> void:
	interacting_interface = using_interface
	ToggleInterfaceMode(inventory_interface, "open")
	ToggleInterfaceMode(interacting_interface, "open")

# Information
# Use - External
# By - Attached object of interacting interface
# For - Severs interface interaction between current interfaces
# Explanation -
#	Sets inventory and the interacting interface into closed modes
# Debug - N/A
func CloseInterfaces() -> void:
	ToggleInterfaceMode(inventory_interface, "close")
	ToggleInterfaceMode(interacting_interface, "close")

# Information
# Use - Internal
# By - OpenInterfaces, CloseInterfaces
# For - Puts interfaces into required modes for appropiate interface logic
# Explanation -
#	If opening:
#		Uses the interface's open method to make it visible
#		Locks the interface from being opened/closed in other ways
#		Tells the interface it is being used in an interaction to allow 
#			correct handling
#		Connects appropiate signals for logic
#	If closing:
#		Uses the interface's close method to make it invisible
#		Unlocks the interface from being opened/closed in other ways
#		Tells the interface it is no longer being used in an interaction to 
#			allow correct handling
#		Disconnects all signals
# Debug - N/A
func ToggleInterfaceMode(interface: Interface, mode: String) -> void:
	if mode == "open":
		interface.OpenInterface()
		interface.lock_open_close = true
		interface.being_used_in_interface_interaction = true
		interface.full_stack_movement.connect(DoFullStackInteraction)
		interface.single_item_movement.connect(DoSingleItemInteraction)
	if mode == "close":
		interface.CloseInterface()
		interface.lock_open_close = false
		interface.being_used_in_interface_interaction = false
		interface.full_stack_movement.disconnect(DoFullStackInteraction)
		interface.single_item_movement.disconnect(DoSingleItemInteraction)

@warning_ignore("unused_parameter")
# Information
# Use - Overriden Function
func DoFullStackInteraction(data: Dictionary) -> void:
	pass

@warning_ignore("unused_parameter")
# Information
# Use - Overriden Function
func DoSingleItemInteraction(data: Dictionary) -> void:
	pass

# Information
# Use - Internal by Child Classes
# By - Child Classes - FullStackInteraction, SingleItemInteractionFromInventory, SingleItemInteractionFromShop
# For - Adds a new shop item to the inventory contents and manager
# Explanation -
#	If item in contents, print error and return
#	Create entry for item in inventory contents
#	Set entry amount to given amount
#	Uses inventory manager add to inventory method without signal to allow
#		for controlled logic here
# Debug - Error print statements:
#	Item already present in contents
# Debug - Optional print statements:
#	Amount of item added
func AddToInventory(item_name: String, amount: int) -> void:
	var islotcomp = inventory_interface.slot_item_assignment_component
	if islotcomp.current_contents.has(item_name):
		print("Error adding new " + item_name + " to inventory, it is already present.")
	else:
		# Adds without signal so we can deal with slot logic in this script itself
		InventoryManager.AddItemToInventoryWithoutSignal(item_name, amount)
		islotcomp.current_contents[item_name] = amount
		#print("There is now " + str(islotcomp.current_contents[item_name]) + " " + item_name + " in the inventory interface contents.")
		#print("There is now " + str(InventoryManager.inventory[item_name]) + " " + item_name + " in the inventory.")

# Information
# Use - Internal by Child Classes
# By - Child Classes - FullStackInteraction, SingleItemInteractionFromStorage, SingleItemInteractionFromShop
# For - Removes all stored amounts of the given item from the inventory interface and manager
# Explanation -
#	If item in contents, erase dictionary entry
#	If item not in contents, print error, print current contents
#	Uses inventory manager take from dictionary method without signal for
#		controlled logic here
# Debug - Error print statements:
#	Item not present in contents
func RemoveFromInventory(item_name: String) -> void:
	var islotcomp = inventory_interface.slot_item_assignment_component
	if islotcomp.current_contents.has(item_name) and InventoryManager.inventory.has(item_name):
		# Removes without signal so we can deal with slot logic in this script itself
		InventoryManager.RemoveItemFromInventoryWithoutSignal(item_name)
		islotcomp.current_contents.erase(item_name)
		#print(item_name + " removed from inventory and inventory interface contents.")
	else:
		print("Error removing " + item_name + " from inventory or inventory interface contents, it is not present.")
		print("Current inventory: " + str(InventoryManager.inventory))
		print("Current inventory interface contents: " + str(islotcomp.current_contents))

# Information
# Use - Internal by Child Classes
# By - Child Classes - FullStackInteraction, SingleItemInteractionFromStorage, SingleItemInteractionFromShop
# For - Gives the given slot a reference to an item
# Explanation -
#	Uses slot's set item method to have it be a reference to the given item
# Debug - N/A
func SetupInventorySlot(item_name: String, slot: InventorySlot) -> void:
	slot.SetItem(item_name)

# Information
# Use - Internal by Child Classes
# By - Child Classes - FullStackInteraction, SingleItemInteractionFromStorage, SingleItemInteractionFromShop
# For - Removes the reference to its item from the given slot
# Explanation -
#	Use slot's remove item method to remove the stored item and amount from slot
# Debug - N/A
func ClearInventorySlot(slot: InventorySlot) -> void:
	slot.RemoveItem()

# Information
# Use - Internal by Child Classes
# By - Child Classes - FullStackInteraction, SingleItemInteractionFromInventory, SingleItemInteractionFromStorage
# For - Adds a new item to the inventory contents and manager
# Explanation -
#	If item in contents, increase amount of entry in contents by given amount
#		Then increase amount of entry in manager without signal for controlled
#			logic here
#	If item not in contents, print error
# Debug - Error print statements:
#	Item not present in contents
# Debug - Optional print statements:
#	Amount of item before
#	Amount of item after
func UpdateInventoryAmounts(item_name: String, amount_added: int) -> void:
	var islotcomp = inventory_interface.slot_item_assignment_component
	if item_name in islotcomp.current_contents:
		#print("There is currently " + str(islotcomp.current_contents[item_name]) + item_name + " in the inventory interface contents.")
		#print("There is currently " + str(InventoryManager.inventory[item_name]) + item_name + " in the inventory.")
		InventoryManager.AddItemToInventoryWithoutSignal(item_name, amount_added)
		islotcomp.current_contents[item_name] += amount_added
		#print("There is now " + str(islotcomp.current_contents[item_name]) + item_name + " in the inventory interface contents.")
		#print("There is now " + str(InventoryManager.inventory[item_name]) + item_name + " in the inventory.")
	else:
		print("Attempt to add to an existing inventory slot failed, " + item_name + " not present in inventory.")

# Information
# Use - Internal by Child Classes
# By - Child Classes - FullStackInteraction, SingleItemInteractionFromInventory
# For - Updates the label showcasing the amount of the given item on the
#		slot referencing it
# Explanation -
#	Finds slot referencing item
#	Uses slot's update amount label method to update its label
# Debug - Error print statements
#	No slot referencing item
func UpdateInventorySlotAmounts(item_name: String) -> void:
	var slot = FindSlotWithItem("inventory", item_name)
	slot.UpdateAmountLabel(item_name)
	
	if slot == null:
		print("Error finding " + item_name + " in inventory slots.")

# Information
# Use - Internal by Child Classes
# By - Child Classes - SingleItemInteractionFromInventory
# For - Reduces amount of given item by one in inventory interface and manager
# Explanation -
#	If item in contents, reduce stored amount
#	If item not in contents, print error, print current contents
# Debug - Error print statements:
#	Item not present in contents
func RemoveOneFromInventory(item_name: String) -> void:
	var islotcomp = inventory_interface.slot_item_assignment_component
	if item_name in islotcomp.current_contents.keys():
		#print("There are currently " + str(islotcomp.current_contents[item_name]) + " " + item_name + " in inventory interface contents and manager.")
		islotcomp.current_contents[item_name] -= 1
		InventoryManager.TakeItemFromInventoryWithoutSignal(item_name, 1)
		#print("There are now " + str(islotcomp.current_contents[item_name]) + " " + item_name + " in inventory interface contents and manager.")
	else:
		print("Error removing " + item_name + " from inventory interface contents and manager. It is not present.")
