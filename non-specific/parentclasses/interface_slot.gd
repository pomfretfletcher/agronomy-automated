class_name InterfaceSlot
extends Panel


# Connected interface that will handle logic using this slot
var interface_handler: InterfaceHandler

# Connected children exports
@export var slot_icon: TextureRect
@export var amount_label: Label
@export var price_label: Label

# Logic state variables
var is_empty: bool = true
var is_focused: bool = false
var is_hovered: bool = false

# Data storage variables
var item_name: String
var amount: int
var price: int = -1


# Function Information
# Use - Interface Use
# Does - Set normal style to slot on interface creation
func _ready() -> void:
	SetNormalStyle()


# Function Information
# Use - Interface Use
# Does - Set internal item reference to given item, and state to having an item
func AssignItem(given_name: String) -> void:
	item_name = given_name
	is_empty = false


# Function Information
# Use - Interface Use
# Does - Set icon to given icon
func AssignIcon(given_icon: Texture2D) -> void:
	slot_icon.texture = given_icon


# Function Information
# Use - Interface Use
# Does - Removes all references to the item from this slot and state to not having an item
func RemoveItem() -> void:
	item_name = ""
	is_empty = true
	slot_icon.texture = null
	amount_label.text = ""
	price_label.text = ""
	price = 0
	amount = 0


# Function Information
# Use - Interface Use
# Does - Formats this slot's amount label based on the stored price within 
func AssignAmountLabel() -> void:
	if amount != null and amount > 1:
		amount_label.text = "x" + str(amount)
	elif amount == null:
		print("Error setting amount of item " + item_name + " in slot " + str(self) + ", the amount is null.")
	else:
		amount_label.text = ""


# Function Information
# Use - Interface Use
# Does - Formats this slot's price label based on the stored price within 
func AssignPriceLabel() -> void:
	if price == null:
		print("Error setting price of item " + item_name + " in slot " + str(self) + ", the price is null.")
	elif price != 0:
		price_label.text = str(GlobalData.currency_symbol) + str(price)
	else:
		price_label.text = ""


# Function Information
# Use - Interface Use
# Does - Sets internal price to showcased price value, then sets label value to that amount
func UpdatePriceLabel(given_price: int) -> void:
	price = given_price
	if price != 0:
		price_label.text = str(GlobalData.currency_symbol) + str(price)
	else:
		price_label.text = ""


# Function Information
# Use - Interface Use
# Does - Highlights the slot when the player's mouse hovers over
func _on_mouse_entered() -> void:
	if !is_focused: 
		SetHoveredStyle()


# Function Information
# Use - Interface Use
# Does - Unhighlights the slot once the player's mouse stops hovering over
func _on_mouse_exited() -> void:
	if !is_focused: 
		SetNormalStyle()
	is_hovered = false


# Function Information
# Use - Interface Use
# Does - Called on player input with the slot, navigates to correct handling method to allow
#		for item exchange between interfaces and within them
func _gui_input(event: InputEvent) -> void:
	if not event is InputEventMouseButton:
		return
	
	if event.is_pressed():
		HandleSingleClickInput(event)


# Function Information
# Use - Interface Use
# Does - Navigates to the correct input handling method based on player gui input to allow
#		exchange of items between interfaces and movement of items within
func HandleSingleClickInput(event: InputEvent) -> void:
	if event.button_index == MOUSE_BUTTON_LEFT:
		HandleLMCInput()
	elif event.button_index == MOUSE_BUTTON_RIGHT:
		HandleRMCInput()


# Function Information
# Use - Interface Use
# Does - Handles exchange of items between interfaces and movement of items within,for inputs 
#		using a left mouse click
func HandleLMCInput() -> void:
	var cursor_has_own_item = true if (PreviewCursorHandler.held_data.has("item") and PreviewCursorHandler.held_data["item"] == item_name) else false
	var no_item_in_cursor = true if PreviewCursorHandler.data_preview_cursor == null else false
	
	# Add item from cursor to slot
	if not no_item_in_cursor:
		var held_item = PreviewCursorHandler.held_data["item"]
		var held_amount = PreviewCursorHandler.held_data["amount"]
		
		# All items from cursor into this slot, calling appropiate method depending on whether
		# this slot has the cursor item or no item
		if is_empty:
			interface_handler.AddNewItemToSlot(self, held_item, held_amount, true)
		elif held_item == item_name:
			interface_handler.AddExistingItemToSlot(self, held_item, held_amount, true)
		
		# Swap all items from slot and cursor with each other
		elif held_item != item_name:
			interface_handler.SwapItemsOfCursorAndSlot(self)
	
	# All items picked up from slot
	elif not is_empty and (no_item_in_cursor or cursor_has_own_item):
		interface_handler.MoveItemFromSlotToCursor(self, amount)


# Function Information
# Use - Interface Use
# Does - Handles exchange of items between interfaces and movement of items within, for inputs 
#		using a right mouse click
func HandleRMCInput() -> void:
	var cursor_has_own_item = true if (PreviewCursorHandler.held_data.has("item") and PreviewCursorHandler.held_data["item"] == item_name) else false
	var no_item_in_cursor = true if PreviewCursorHandler.data_preview_cursor == null else false
	
	if (no_item_in_cursor or cursor_has_own_item) and not Input.is_key_pressed(KEY_CTRL):
		# One item from slot into cursor
		if not is_empty:
			interface_handler.MoveItemFromSlotToCursor(self, 1)
			
	elif not no_item_in_cursor:
		var held_item = PreviewCursorHandler.held_data["item"]
		
		# Add 1 of the items stored in the cursor to this slot, calls appropiate method dependent
		# on whether this slot has any items in it
		if is_empty:
			interface_handler.AddNewItemToSlot(self, held_item, 1, true)
		elif held_item == item_name:
			interface_handler.AddExistingItemToSlot(self, held_item, 1, true)


# Function Information
# Use - Interface Use
# Does - If an external source removes focus, or another slot is clicked, return to normal style
func _on_focus_exited() -> void:
	RemoveFocusFromSlot()


# Function Information
# Use - Interface Use
# Does - If focus forced away from slot, revert to normal style
func RemoveFocusFromSlot() -> void:
	SetNormalStyle()
	release_focus()


# Function Information
# Use - Interface Use
# Does - Set style and internal states for non-hovered, non-focused slots
func SetNormalStyle() -> void:
	add_theme_stylebox_override("panel", get_theme_stylebox("normal", "OnInterfaceSlot"))
	is_focused = false; is_hovered = false


# Function Information
# Use - Interface Use
# Does - Set style and internal states for hovered, non-focused slots
func SetHoveredStyle() -> void:
	add_theme_stylebox_override("panel", get_theme_stylebox("hovered", "OnInterfaceSlot"))
	is_focused = false; is_hovered = true


# Function Information
# Use - Interface Use
# Does - Set style and internal states for non-hovered, focused slots
func SetFocusedStyle() -> void:
	add_theme_stylebox_override("panel", get_theme_stylebox("focused", "OnInterfaceSlot"))
	is_focused = true; is_hovered = false


# Function Information
# Use - Interface Use
# Does - Takes a given amount from the interface handler to store and then formats it visually
func SetAmount(given_amount: int) -> void:
	amount = given_amount
	AssignAmountLabel()


# Function Information
# Use - Interface Use
# Does - Takes a given price from the interface handler to store and then formats it visually
func SetPrice(given_price: int) -> void:
	price = given_price
	AssignPriceLabel()


# Function Information
# Use - Interface Use
# Does - Takes a given item from the interface handler to store and then formats it visually
func SetItem(given_item: String) -> void:
	var icon = Database.database[given_item].texture
	AssignItem(given_item)
	AssignIcon(icon)


# Function Information
# Use - Interface Use
# Does - Allows interface handler to change the amount of the item stored within this slot
#		without resetting and overriding the current amount
func IncreaseAmount(amount_change: int) -> void:
	if amount == 0 or amount == null or item_name == "":
		print("Cannot increase amount of item " + item_name + " in slot " + str(self) + ", it has no item or has none of its item [Should have either an amount or no item].")
		return
	
	amount += amount_change
	AssignAmountLabel()


# Function Information
# Use - Interface Use
# Does - Allows interface handler to change the amount of the item stored within this slot
#		without resetting and overriding the current amount
func DecreaseAmount(amount_change: int) -> void:
	if amount == 0 or amount == null or item_name == "":
		print("Cannot decrease amount of item " + item_name + " in slot " + str(self) + ", it has no item or has none of its item [Should have either an amount or no item].")
		return
	if amount_change > amount:
		print("Cannot decrease amount of item " + item_name + " in slot " + str(self) + ", it only has " + str(amount) + " of that item.")
		return
	
	amount -= amount_change
	
	if amount == 0:
		RemoveItem()
	else:
		AssignAmountLabel()
