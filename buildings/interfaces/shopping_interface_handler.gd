class_name ShoppingInterfaceHandler
extends BuildingInterfaceHandler


func SetupInitialData() -> void:
	super()
	connected_building = connected_building as ShopPoint
	for item in connected_building.starting_stock_order:
		if item in connected_building.starting_stock:
			var amount = connected_building.starting_stock[item]
			AddItemToInterface(item, amount)


func OpenInterface() -> void:
	super()
	ShowPrices()


# Function Information - Overriden by Child Classes
# Use - Interface Use
# Does - Returns whether the given amount of the given item can be taken from the interface.
#		In child classes, will check for time completion or item costs for example.
@warning_ignore("unused_parameter")
func CanItemBeTakenFromInterface(data: Dictionary) -> bool:
	var purchase_cost_per_unit = DecideBuyPriceOfItem(data["item"])
	var total_purchase_cost = purchase_cost_per_unit * data["amount"]
	return CurrencyManager.CanSpendMoney(total_purchase_cost)


# Function Information - Override of Parent Class
# Use - Interface Use
# Does - Gives the player an amount of money worth of the items they placed in the interface
func HandleItemAddedToInterface(data: Dictionary) -> void:
	var purchase_cost_per_unit = DecideSellPriceOfItem(data["item"])
	var total_purchase_cost = purchase_cost_per_unit * data["amount"]
	return CurrencyManager.GainMoney(total_purchase_cost)


# Function Information - Override of Parent Class
# Use - Interface Use
# Does - Takes an amount of money from the player worth the items they took from the interface
func HandleItemRemovedFromInterface(data: Dictionary) -> void:
	var purchase_cost_per_unit = DecideBuyPriceOfItem(data["item"])
	var total_purchase_cost = purchase_cost_per_unit * data["amount"]
	return CurrencyManager.ReduceMoney(total_purchase_cost)


func ShowPrices() -> void:
	for page in interface_slots:
		for row in page:
			for slot in row:
				slot = slot as InterfaceSlot
				if not slot.is_empty:
					slot.SetPrice(DecideBuyPriceOfItem(slot.item_name))


# Function Information - Override of Parent Class
# Use - Interface Use
# Does - Deletes the item of the slot being clicked on and then places the cursor item into it
func SwapItemsOfCursorAndSlot(slot: InterfaceSlot) -> void:
	# Check if new data can even be added to shop, if it can, continue
	var cursor_item: String = PreviewCursorHandler.held_data["item"]
	var cursor_amount: int = PreviewCursorHandler.held_data["amount"]
	var cursor_data = {"slot_added_to": slot, "item": cursor_item, "amount": cursor_amount}
	if not CanItemBeAddedToInterface(cursor_data):
		return
	
	# Erase the item currently in this slot
	slot.RemoveItem()
	
	# Take the items from the cursor
	PreviewCursorHandler.held_data["source"].has_item_in_cursor = false
	PreviewCursorHandler.RemovePreviewCursor()
	
	# Place the items previously in the cursor into the slot
	slot.SetItem(cursor_item)
	slot.SetAmount(cursor_amount)
	
	HandleItemAddedToInterface(cursor_data)


func DecideBuyPriceOfItem(item: String) -> int:
	return CurrencyManager.GetBasePurchasePrice(item, 1)


func DecideSellPriceOfItem(item: String) -> int:
	return CurrencyManager.DecideBaseSellPrice(item, 1)
