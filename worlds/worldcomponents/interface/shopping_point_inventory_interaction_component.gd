class_name SellPointInventoryInteractionComponent
extends InventoryInteractionComponent


# Information
# Use - External
# By - Attached object of interacting interface
# For - Creates interface interaction between inventory and given interface
# Explanation -
#	Sets inventory and the interacting interface into open modes
#	Places price labels for each item of the inventory onto their slots
func OpenInterfaces(using_interface: Interface) -> void:
	interacting_interface = using_interface
	ToggleInterfaceMode(inventory_interface, "open")
	TogglePriceLabels(inventory_interface, "apply")
	ToggleInterfaceMode(interacting_interface, "open")
	TogglePriceLabels(interacting_interface, "apply")
	ToggleHotbarInterfaceMode("open")
	ToggleHotbarPriceLabels("apply")


# Information
# Use - External
# By - Attached object of interacting interface
# For - Severs interface interaction between current interfaces
# Explanation -
#	Sets inventory and the interacting interface into closed modes
func CloseInterfaces() -> void:
	ToggleInterfaceMode(inventory_interface, "close")
	TogglePriceLabels(inventory_interface, "remove")
	ToggleInterfaceMode(interacting_interface, "close")
	TogglePriceLabels(interacting_interface, "remove")
	ToggleHotbarInterfaceMode("close")
	ToggleHotbarPriceLabels("remove")


func TogglePriceLabels(interface: Interface, mode: String) -> void:
	var islotcomp = interface.slot_item_assignment_component
	
	if mode == "apply":
		for row in islotcomp.current_slots:
			for slot in row:
				var cur_slot = slot as InterfaceSlot
				if !cur_slot.is_empty:
					cur_slot.UpdatePriceLabel(GetSellValue(cur_slot.item_name, 1))
	
	if mode == "remove":
		for row in islotcomp.current_slots:
			for slot in row:
				var cur_slot = slot as InterfaceSlot
				if !cur_slot.is_empty:
					cur_slot.UpdatePriceLabel(0)


func ToggleHotbarPriceLabels(mode: String) -> void:
	if mode == "apply":
		for slot in hotbar_interface.hotbar_slots:
			var cur_slot = slot as InterfaceSlot
			if !cur_slot.is_empty:
				cur_slot.UpdatePriceLabel(GetSellValue(cur_slot.item_name, 1))
	
	if mode == "remove":
		for slot in hotbar_interface.hotbar_slots:
			var cur_slot = slot as InterfaceSlot
			if !cur_slot.is_empty:
				cur_slot.UpdatePriceLabel(0)


# Information
# Use - External
# By - Connected to signal of opened interfaces
# For - Calls internal method
# Explanation -
#	If passed data, call internal method
func DoFullStackInteraction(data: Dictionary) -> void:
	if (data["to"] is ShoppingSlot or data["from"] is ShoppingSlot) and (data["to"] is InventorySlot or data["from"] is InventorySlot):
		FullStackInteraction(data)


# Information - Redo Explanation?
# Use - Internal
# By - DoFullStackInteraction
# For - Purchase or selling of all of an item from either inventory to shop
#		or shop to inventory
# Explanation -
#	Stores given variables in more readable and usable versions
#	If shopping:
#		Gain currency based on sell value
#		Remove item from inventory and slots
#		If dragging onto open slot:
#			If new item to contents, add to contents and the new slot
#			If existing item, update entry amount and slot labels
#		If dropping onto slot with item:
#			If new item to contents, add to contents and the new slot
#				Then place the item that was in this slot in the one from 
#				the inventory
#			If existing item, update entry amount and slot labels
#	If buying:
#		Get whether item and amount is buyable
#		If can't buy, return and end interaction
#		Takes currency based on sell value
#		Remove item from shop and slots
#		If dragging onto open slot:
#			If new item to contents, add to contents and the new slot
#			If existing item, update entry amount and slot labels
#		If dragging onto slot with item:
#			If new item to contents, add to contents and the new slot
#				Then place the item that was in this slot in the one from
#				the shop
#			If existing item, update entry amount and slot labels
# Debug - Optional print statements:
#	Item cannot be bought
func FullStackInteraction(data: Dictionary) -> void:
	# Turns slots into more readable and usable vars by identifying which is
	# inventory and which is shop
	var used_inventory_slot = data["from"] if data["from"] is InventorySlot else data["to"]
	
	var selling = (used_inventory_slot == data["from"])
	var buying = (used_inventory_slot == data["to"])
	
	# No buy/sell if no item moved
	if data["from"].item_name == "":
		# Return from slot to previous look
		data["from"].RemoveFocusFromSlot()
		return
	
	if selling:
		FullStackInteractionFromInventory(data)
	elif buying:
		FullStackInteractionFromShop(data)
		
	# Return from slot to previous look
	data["from"].RemoveFocusFromSlot()


func FullStackInteractionFromInventory(data: Dictionary) -> void:
	var from_slot: InventorySlot = data["from"]
	var to_slot: ShoppingSlot = data["to"]
	
	var moved_item = {
		"name": from_slot.item_name,
		"amount": from_slot.amount,
	}
	var swapped_item = {
		"name": to_slot.item_name,
		"amount": to_slot.amount,
	}
	
	var sell_value = GetSellValue(moved_item["name"], moved_item["amount"])
	CurrencyManager.GainMoney(sell_value)
	RemoveFromInventory(moved_item["name"])
	ClearInventorySlot(from_slot)
	var is_new_item_in_shop = CheckIfNewShopItem(moved_item["name"])
	if to_slot.is_empty:
		if is_new_item_in_shop:
			AddToShop(moved_item["name"], moved_item["amount"])
			SetupShopSlot(to_slot, moved_item["name"])
			to_slot.UpdatePriceLabel(GetSellValue(moved_item["name"], 1))
		else:
			UpdateShopAmounts(moved_item["name"], moved_item["amount"])
			UpdateShopSlotAmounts(moved_item["name"])
	else:
		if is_new_item_in_shop:
			# Will override what is in that slot with new item
			RemoveFromShop(swapped_item["name"])
			ClearShopSlot(to_slot)
			AddToShop(moved_item["name"], moved_item["amount"])
			SetupShopSlot(to_slot, moved_item["name"])
			to_slot.UpdatePriceLabel(GetSellValue(moved_item["name"], 1))
		else:
			UpdateShopAmounts(moved_item["name"], moved_item["amount"])
			UpdateShopSlotAmounts(moved_item["name"])
	
	#print(moved_item["item"] + " sold for " + str(sell_value) + "!")
	#print("You now have " + str(CurrencyManager.current_money) + " currency remaining.")


func FullStackInteractionFromShop(data: Dictionary) -> void:
	var from_slot: ShoppingSlot = data["from"]
	var to_slot: InventorySlot = data["to"]
	
	var moved_item = {
		"name": from_slot.item_name,
		"amount": from_slot.amount,
	}
	var swapped_item = {
		"name": to_slot.item_name,
		"amount": to_slot.amount,
	}
	
	var can_be_bought = CheckIfCanBeBought(moved_item["name"], moved_item["amount"])
	var sell_value = CurrencyManager.DecideSellPrice(moved_item["name"], moved_item["amount"])
	
	if !can_be_bought:
		#print(item_name + " cannot be bought, not enough currency.")
		return
			
	CurrencyManager.ReduceMoney(sell_value)
	RemoveFromShop(moved_item["name"])
	ClearShopSlot(from_slot)
	
	if to_slot.is_empty:
		if moved_item["name"] not in inventory_interface.slot_item_assignment_component.current_contents.keys():
			AddToInventory(moved_item["name"], moved_item["amount"])
			SetupInventorySlot(moved_item["name"], to_slot)
			to_slot.UpdatePriceLabel(GetSellValue(moved_item["name"], 1))
		else:
			UpdateInventoryAmounts(moved_item["name"], moved_item["amount"])
			var recieving_slot = inventory_interface.slot_item_assignment_component.FindSlotWithItem(moved_item["name"])
			if recieving_slot:
				UpdateInventoryAmounts(recieving_slot, moved_item["name"])
			else:
				UpdateHotbarSlotAmounts(moved_item["name"])
	else:
		if moved_item["name"] not in inventory_interface.slot_item_assignment_component.current_contents.keys():
			# Sell item in to slot, buy item in from slot
			var swap_sell_value = GetSellValue(swapped_item["name"], swapped_item["amount"])
			CurrencyManager.GainMoney(swap_sell_value)
			RemoveFromInventory(swapped_item["name"])
			ClearInventorySlot(to_slot)
			AddToInventory(moved_item["name"], moved_item["amount"])
			SetupInventorySlot(moved_item["name"], to_slot)
			to_slot.UpdatePriceLabel(GetSellValue(moved_item["name"], 1))
			AddToShop(swapped_item["name"], swapped_item["amount"])
			SetupShopSlot(from_slot, swapped_item["name"])
			from_slot.UpdatePriceLabel(GetSellValue(swapped_item["name"], 1))
		else:
			UpdateInventoryAmounts(moved_item["name"], moved_item["amount"])
			var recieving_slot = inventory_interface.slot_item_assignment_component.FindSlotWithItem(moved_item["name"])
			if recieving_slot:
				UpdateInventoryAmounts(recieving_slot, moved_item["name"])
			else:
				UpdateHotbarSlotAmounts(moved_item["name"])
	
	#print(moved_item["name"] + " sold for " + str(sell_value) + "!")
	#print("You now have " + str(CurrencyManager.current_money) + " money remaining.")


# Information
# Use - External
# By - Connected to signal of opened interfaces
# For - Calls internal method
# Explanation -
#	If passed data, call internal method
func DoSingleItemInteraction(data: Dictionary) -> void:
	if data != null and data["from"] != null:
		SingleItemInteraction(data)


# Information
# Use - Internal
# By - DoSingleItemInteraction
# For - Calls appropiate single item interaction method
# Explanation -
#	Calls from inventory method if passed data's type is inventory slot
#	Calls from shop method is passed data's type is shop slot
func SingleItemInteraction(data: Dictionary) -> void:
	if data["from"] is InventorySlot:
		SingleItemInteractionFromInventory(data["from"])
	elif data["from"] is ShoppingSlot:
		SingleItemInteractionFromShop(data["from"])


# Information
# Use - Internal
# By - SingleItemInteraction
# For - Moving single items from inventory interface to shop interface
# Explanation -
#	Add one of item to shop interface (If space)
#	If no space, return and stop interaction
#	Gain currency based on sell value
#	Reduces amount of item by one in inventory interface
#	If last of item removed from inventory, delete reference from inventory
# Debug - Optional print statements:
#	No space remaining in shop
#	Item sold
func SingleItemInteractionFromInventory(from_slot: InventorySlot) -> void:
	var sent_item: String = from_slot.item_name
	var sell_value = GetSellValue(sent_item, 1)
	
	var shopslotcomp = interacting_interface.slot_item_assignment_component
	if sent_item in shopslotcomp.current_contents.keys():
		CurrencyManager.GainMoney(sell_value)
		UpdateShopAmounts(sent_item, 1)
		UpdateShopSlotAmounts(sent_item)
		RemoveOneFromInventory(sent_item)
		UpdateInventoryOrHotbarSlotAmounts(from_slot, sent_item)
	
	elif sent_item not in shopslotcomp.current_contents.keys():
		# Find first empty shop slot
		var to_slot: ShoppingSlot = FindFirstEmptySlot("shop")
		
		if to_slot:
			CurrencyManager.GainMoney(sell_value)
			AddToShop(sent_item, 1)
			SetupShopSlot(to_slot, sent_item)
			to_slot.UpdatePriceLabel(sell_value)
			RemoveOneFromInventory(sent_item)
			UpdateInventoryOrHotbarSlotAmounts(from_slot, sent_item)
		if to_slot == null:
			print("No remaining slots in shop to move item into.")
			return
	
	# If none left in inventory, remove item from inventory contents and slots
	var inventoryslotcomp = inventory_interface.slot_item_assignment_component
	if inventoryslotcomp.current_contents[sent_item] == 0:
		RemoveFromInventory(sent_item)
		ClearInventorySlot(from_slot)


# Information
# Use - Internal
# By - SingleItemInteraction
# For - Moving single items from shop interface to inventory interface
# Explanation -
#	Checks if item can be bought
#	If can't, return and stop interaction
#	Add one of item to inventory interface (If space)
#	If no space, return and stop interaction
#	Takes currency based on sell value
#	Reduces amount of item by one in shop interface
#	If last of item removed from shop, delete reference from shop
# Debug - Optional print statements:
#	No space remaining in inventory
#	Not enough money to buy item
#	Item bought
func SingleItemInteractionFromShop(from_slot: ShoppingSlot) -> void:
	var sent_item: String = from_slot.item_name
	var sell_value = GetSellValue(sent_item, 1)
	
	var can_be_bought = CheckIfCanBeBought(sent_item, 1)
	if !can_be_bought:
		#print("Error buying " + item_name + ", not enough currency.")
		return
	
	var inventoryslotcomp = inventory_interface.slot_item_assignment_component
	if sent_item in inventoryslotcomp.current_contents.keys():
		CurrencyManager.ReduceMoney(sell_value)
		UpdateInventoryAmounts(sent_item, 1)
		UpdateInventorySlotAmounts(sent_item)
		RemoveOneFromShop(sent_item)
		UpdateShopSlotAmounts(sent_item)
	
	elif sent_item not in inventoryslotcomp.current_contents:
		var to_slot: InventorySlot = FindFirstEmptySlot("inventory")
		
		if to_slot:
			CurrencyManager.ReduceMoney(sell_value)
			AddToInventory(sent_item, 1)
			SetupInventorySlot(sent_item, to_slot)
			to_slot.UpdatePriceLabel(sell_value)
			RemoveOneFromShop(sent_item)
			UpdateShopSlotAmounts(sent_item)
		elif to_slot == null:
			#print("No remaining slots in inventory to move item into.")
			return
	
	# If none left in shop, remove item from shop contents and slots
	var shopslotcomp = interacting_interface.slot_item_assignment_component
	if shopslotcomp.current_contents[sent_item] == 0:
		RemoveFromShop(sent_item)
		ClearShopSlot(from_slot)
	
	#print(data["item"] + " bought for " + str(sell_value) + "!")
	#print("You now have " + str(CurrencyManager.current_money) + " currency remaining.")


# Information
# Use - Internal
# By - FullStackInteraction, SingleItemInteractionFromShop
# For - Deciding whether the player is able to buy a specific amount of a
#		specific item.
# Explanation -
#	Decide the buy price of amount of specific item
#	Will check for npc info and buy limits - [Not Implemented]
#	Returns whether the player has enough currency to do the purchase
func CheckIfCanBeBought(item: String, amount: int) -> bool:
	var total_cost = CurrencyManager.DecideBuyPrice(item, amount)
	return CurrencyManager.CanSpendMoney(total_cost)


# Information
# Use - Internal
# By - FullStackInteraction, SingleItemInteractionFromShop, SingleItemInteractionFromInventory
# For - Calculates the price for a exchange of the amount of the item
# Explanation -
#	Gets base price from currency manager
#	Applies npc info and world factors to price - [Not Implemented]
#	Returns full result
func GetSellValue(item: String, amount: int) -> int:
	var total_cost = CurrencyManager.DecideSellPrice(item, amount)
	return total_cost


# Information
# Use - Internal
# By - FullStackInteraction
# For - Returns whether the given item is currently an item in the shop
#		interface
# Explanation -
#	Returns whether given item in dictionary contents of shop interface
func CheckIfNewShopItem(item_name: String) -> bool:
	var islotcomp = interacting_interface.slot_item_assignment_component
	return !item_name in islotcomp.current_contents.keys()


# Information
# Use - Internal
# By - SingleItemInteractionFromShop
# For - Reduces amount of given item by one in shop interface
# Explanation -
#	If item in contents, reduce stored amount
#	If item not in contents, print error, print current contents
# Debug - Error print statements:
#	Item not present in contents
func RemoveOneFromShop(item_name: String) -> void:
	var islotcomp = interacting_interface.slot_item_assignment_component
	if item_name in islotcomp.current_contents.keys():
		#print("There are currently " + str(islotcomp.current_contents[item_name]) + " " + item_name + " in shop contents.")
		islotcomp.current_contents[item_name] -= 1
		#print("There are now " + str(islotcomp.current_contents[item_name]) + " " + item_name + " in shop contents.")
	else:
		print("Error removing " + item_name + " from shop contents. It is not present.")
		print("Current shop contents: " + str(islotcomp.current_contents))


# Information
# Use - Internal
# By - FullStackInteraction, SingleItemInteractionFromShop
# For - Removes all stored amounts of the given item from the shop interface
# Explanation -
#	If item in contents, erase dictionary entry
#	If item not in contents, print error, print current contents
# Debug - Error print statements:
#	Item not present in contents
func RemoveFromShop(item_name: String) -> void:
	var islotcomp = interacting_interface.slot_item_assignment_component
	if islotcomp.current_contents.has(item_name):
		islotcomp.current_contents.erase(item_name)
		#print(item_name + " removed from shop contents.")
	else:
		print("Error removing " + item_name + " from shop, it is not present.")
		print("Current shop contents: " + str(islotcomp.current_contents))


# Information
# Use - Internal
# By - FullStackInteraction, SingleItemInteractionFromShop
# For - Removes the reference to its item from the given slot
# Explanation -
#	Use slot's remove item method to remove the stored item and amount from slot
func ClearShopSlot(slot: ShoppingSlot) -> void:
	slot.RemoveItem()


# Information
# Use - Internal
# By - FullStackInteraction, SingleItemInteractionFromInventory
# For - Adds a new shop item to the shop contents
# Explanation -
#	If item in contents, print error and return
#	Create entry for item in shop contents
#	Set entry amount to given amount
# Debug - Error print statements:
#	Item already present in contents
# Debug - Optional print statements:
#	Amount of item added
func AddToShop(item_name: String, amount: int) -> void:
	var islotcomp = interacting_interface.slot_item_assignment_component
	if item_name in islotcomp.current_contents.keys():
		print("Error adding " + item_name + " to shop interface contents. Already present.")
		return
	
	islotcomp.current_contents[item_name] = amount
	#print("There is now " + str(islotcomp.current_contents[item_name]) + " " + item_name + " in the shop interface contents.")


# Information
# Use - Internal
# By - FullStackInteraction, SingleItemInteractionFromInventory, SingleItemInteractionFromShop
# For - Adds a new shop item to the shop contents
# Explanation -
#	If item in contents, increase amount of entry by given amount
#	If item not in contents, print error
# Debug - Error print statements:
#	Item not present in contents
# Debug - Optional print statements:
#	Amount of item before
#	Amount of item after
func UpdateShopAmounts(item_name: String, amount_added: int) -> void:
	var islotcomp = interacting_interface.slot_item_assignment_component
	if item_name in islotcomp.current_contents.keys():
		#print("There is currently " + str(islotcomp.current_contents[item_name]) + " " + item_name + " in the shop interface contents.")
		islotcomp.current_contents[item_name] += amount_added
		#print("There is now " + str(islotcomp.current_contents[item_name]) + " " + item_name + " in the shop interface contents.")
	else:
		print("Error updating " + item_name + " amount in shop interface contents, it is not present.")


# Information
# Use - Internal
# By - FullStackInteraction, SingleItemInteractionFromInventory
# For - Gives the given slot a reference to an item
# Explanation -
#	Uses slot's set item method to have it be a reference to the given item
func SetupShopSlot(slot: ShoppingSlot, item_name: String) -> void:
	slot.SetItem(item_name)


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
func UpdateShopSlotAmounts(item_name: String) -> void:
	var slot = FindSlotWithItem("shop", item_name)
	
	if slot:
		slot.UpdateAmountLabel(item_name)
	if slot == null:
		print("Error finding " + item_name + " in shop slots.")
