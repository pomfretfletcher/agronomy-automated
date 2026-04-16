class_name ShopPoint
extends Building


func _ready() -> void:
	inventory_interaction_component = get_tree().get_first_node_in_group("sellpointinventoryinteractioncomponent")
		

func ConstructStartingInventory() -> void:
	var slotcomp = interface.slot_item_assignment_component as SlotItemAssignmentComponent
	for item in starting_inventory_order:
		if item not in starting_inventory:
			print("Error setting up item " + item + " in shop point initial inventory, no entry in dict.")
			continue
		if starting_inventory[item] <= 0:
			print("Error setting up item " + item + " in shop point initial inventory, value in dictionary not setup properly.")
			continue
			
		slotcomp.current_contents[item] = starting_inventory[item]
		var slot = slotcomp.FindFirstEmptySlot() as ShoppingSlot
		slot.SetItem(item)
