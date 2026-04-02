class_name InventorySlotItemAssignmentComponent
extends SlotItemAssignmentComponent

# Information
# Use - Internal
# By - Game Startup
# For - Initialises data
# Explanation -
#	Connect appropiate signals to inventory manager signals
# Debug - N/A
func _ready() -> void:
	InventoryManager.inventory_changed.connect(UpdateSlots)
	InventoryManager.inventory_cleared.connect(UpdateSlotsAfterClear)
	
func UpdateSlots(item_changed: String) -> void:
	# If new item, add to contents and assign it to first avaiable slot
	if item_changed not in current_contents.keys():
		AddItemToSlots(item_changed)
	
	# If item not in inventory, it has been removed, and can be removed from slots
	if item_changed not in InventoryManager.inventory.keys():
		RemoveItemFromSlots(item_changed)

func UpdateSlotsAfterClear() -> void:
	# Clears all items in slots if inventory cleared
	for item in current_contents.keys():
		RemoveItemFromSlots(item)
	
func AddItemToSlots(item: String) -> void:
	# Set contents value of item to amount in inventory
	current_contents[item] = InventoryManager.inventory[item]
	
	# Cycle through for first empty slot, set slot to show item
	#adderror
	var slot = FindFirstEmptySlot()
	slot.SetItem(item)
	
func RemoveItemFromSlots(item: String) -> void:
	if item not in current_contents.keys():
		print("Error trying to remove " + item + " from inventory contents. It is not present.")
		return
	
	# Cycle through to find slot holding item and stop it showing said item
	#adderror
	var slot = FindSlotWithItem(item)
	slot.RemoveItem()
	current_contents.erase(item)
