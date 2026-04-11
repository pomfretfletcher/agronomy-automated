class_name InterfaceSlot
extends Slot

var slot_item_assignment_component: SlotItemAssignmentComponent
var interface: Interface
var item_name: String
var is_empty: bool = true
var is_focused: bool = false
var is_hovered: bool = false
var amount: int
var price: int
@export var slot_icon: TextureRect
@export var amount_label: Label
@export var price_label: Label

# Function Information
# Use - Interface Use
# Does - Set normal style to slot on interface creation
# Debug - N/A
func _ready() -> void:
	SetNormalStyle()

# Function Information
# Use - Interface Use
# Does - Set internal item reference to given item, and state to having an item
# Debug - N/A
func AssignItem(given_name: String) -> void:
	item_name = given_name
	is_empty = false

# Function Information
# Use - Interface Use
# Does - Set icon to given icon
# Debug - N/A
func AssignIcon(given_icon: Texture2D) -> void:
	slot_icon.texture = given_icon

# Function Information
# Use - Interface Use
# Does - Removes all references to the item from this slot and state to not having an item
# Debug - N/A
func RemoveItem() -> void:
	item_name = ""
	is_empty = true
	slot_icon.texture = null
	amount_label.text = ""
	price_label.text = ""
	price = 0

# Function Information
# Use - Interface Use
# Does - Keep amount label in parity with changing contents of interface
# Debug - N/A
func UpdateAmountLabel(item_changed: String) -> void:
	if item_changed != item_name:
		return
	else:
		AssignAmountLabel()

# Function Information
# Use - Interface Use
# Does - Overriden by Child Classes to decide amount, then called by super to set appropiate label
# Debug - Error statement
#		Amount is null [Item likely not present in interface]
func AssignAmountLabel() -> void:
	if amount != null and amount > 1:
		amount_label.text = "x" + str(amount)
	elif amount == null:
		print("Error setting amount label for slot " + str(self) + ", it's item is not present in its interface contents: " + str(slot_item_assignment_component.current_contents) )
	else:
		amount_label.text = ""

# Function Information
# Use - Interface Use
# Does - Sets all parts of the slot to the new given item
# Debug - N/A
func SetItem(given_item: String) -> void:
	var icon = Database.database[given_item].texture
	AssignItem(given_item)
	AssignIcon(icon)
	AssignAmountLabel()

# Function Information
# Use - Interface Use
# Does - Sets internal price to showcased price value, then sets label value to that amount
# Debug - N/A
func UpdatePriceLabel(given_price: int) -> void:
	price = given_price
	if price != 0:
		price_label.text = str(GlobalData.currency_symbol) + str(price)
	else:
		price_label.text = ""

# Function Information
# Use - Interface Use
# Does - Highlights the slot when the player's mouse hovers over
# Debug - N/A
func _on_mouse_entered() -> void:
	if !is_focused: 
		SetHoveredStyle()

# Function Information
# Use - Interface Use
# Does - Unhighlights the slot once the player's mouse stops hovering over
# Debug - N/A
func _on_mouse_exited() -> void:
	if !is_focused: 
		SetNormalStyle()
	is_hovered = false

# Function Information
# Use - Interface Use
# Does - Either focuses/unfocuses the slot on mouse click, or emits the fact that a single item is being
#		moved during an item interaction
# Debug - N/A
func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		# Left click on slot being hovered on, but not currently focused on
		if !is_focused:
			SetFocusedStyle()
		
		# Left click on slot being focused on, disable the focus, return to hover
		else:
			SetHoveredStyle()
			release_focus()
	
	# Single item attempting to be sent between interfacces
	if event is InputEventMouseButton and event.is_released() and event.button_index == MOUSE_BUTTON_LEFT:
		if not is_empty and interface.being_used_in_interface_interaction:
			var data: Dictionary
			data["from"] = self
			interface.single_item_movement.emit(data)
			SetHoveredStyle()

# Function Information
# Use - Interface Use
# Does - If an external source removes focus, or another slot is clicked, return to normal style
# Debug - N/A
func _on_focus_exited() -> void:
	RemoveFocusFromSlot()

# Function Information
# Use - Interface Use
# Does - If focus forced away from slot, revert to normal style
# Debug - N/A
func RemoveFocusFromSlot() -> void:
	SetNormalStyle()
	release_focus()

# Function Information
# Use - Interface Use
# Does - Set style and internal states for non-hovered, non-focused slots
# Debug - N/A
func SetNormalStyle() -> void:
	add_theme_stylebox_override("panel", get_theme_stylebox("normal", "OnInterfaceSlot"))
	is_focused = false; is_hovered = false

# Function Information
# Use - Interface Use
# Does - Set style and internal states for hovered, non-focused slots
# Debug - N/A
func SetHoveredStyle() -> void:
	add_theme_stylebox_override("panel", get_theme_stylebox("hovered", "OnInterfaceSlot"))
	is_focused = false; is_hovered = true

# Function Information
# Use - Interface Use
# Does - Set style and internal states for non-hovered, focused slots
# Debug - N/A
func SetFocusedStyle() -> void:
	add_theme_stylebox_override("panel", get_theme_stylebox("focused", "OnInterfaceSlot"))
	is_focused = true; is_hovered = false

# Function Information
# Use - Interface Use
# Does - Return data stored in this slot when dragged from within interface use
# Debug - N/A
func _get_drag_data(_at_position):
	if item_name == null:
		return null

	var preview = TextureRect.new()
	preview.texture = slot_icon
	preview.expand = true
	preview.size = Vector2(32, 32)

	set_drag_preview(preview)

	return {
	"item": item_name,
	"from": self,
	"amount": amount
	}

# Function Information
# Use - Interface Use
# Does - Allows drop data to occur with the slot
# Debug - N/A
func _can_drop_data(_at_position, data):
	return data != null
