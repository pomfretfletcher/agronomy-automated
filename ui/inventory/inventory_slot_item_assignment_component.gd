class_name InventorySlotItemAssignmentComponent
extends SlotItemAssignmentComponent

var hotbar_slots: Array[HotbarSlot]
var hotbar_interface: HotbarInterface


# Function Information
# Use - Interface Use, Inventory
# Does - Connect signals and reference to hotbar
func _ready() -> void:
	InventoryManager.inventory_changed.connect(UpdateSlots)
	InventoryManager.inventory_cleared.connect(UpdateSlotsAfterClear)
	hotbar_interface = interface.get("hotbar_interface")


# Function Information
# Use - Interface Use, Inventory
# Does - Adds or removes slot references to items that are changed in contents
func UpdateSlots(item_changed: String) -> void:
	if item_changed not in current_contents.keys():
		AddItemToSlots(item_changed)
	
	if item_changed not in InventoryManager.inventory.keys():
		RemoveItemFromSlots(item_changed)


# Function Information
# Use - Interface Use, Inventory
# Does - Removes all slot references to items
func UpdateSlotsAfterClear() -> void:
	# Clears all items in slots if inventory cleared
	for item in current_contents.keys():
		RemoveItemFromSlots(item)


# Function Information
# Use - Interface Use, Inventory
# Does - Setup a slot to have reference to new item to interface, add item to interface contents
# Debug - Optional Error Statements
#		Item already present in slots/contents
func AddItemToSlots(item: String) -> void:
	if item in current_contents.keys():
		#print("Error adding " + item + " to slots. Already present.")
		return
	
	var slot = FindFirstEmptySlot()
	if slot:
		slot.SetItem(item)
		current_contents[item] = InventoryManager.inventory[item]
	if slot == null:
		print("Error adding " + item + " to slots. No space.")


# Function Information
# Use - Interface Use, Inventory
# Does - Remove reference of given item from its corresponding slot, remove item from interface contents
# Debug - Optional Error Statements
#		Item not present in slots/contents
func RemoveItemFromSlots(item: String) -> void:
	if item not in current_contents.keys():
		#print("Error trying to remove " + item + " from inventory contents. It is not present.")
		return
		
	var slot = FindSlotWithItem(item)
	if slot:
		slot.RemoveItem()
		current_contents.erase(item)
