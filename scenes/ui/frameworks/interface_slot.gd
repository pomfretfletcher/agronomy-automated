class_name InterfaceSlot
extends Slot

var slot_item_assignment_component: SlotItemAssignmentComponent
var interface: Interface

var item_name: String
var is_empty: bool = true
var is_focused: bool = false
var is_hovered: bool = false
var amount: int
@export var slot_icon: TextureRect
@export var slot_label: Label

func _ready() -> void:
	SetNormalStyle()
	
func AssignItem(given_name: String) -> void:
	item_name = given_name
	is_empty = false
	
func AssignIcon(given_icon: Texture2D) -> void:
	slot_icon.texture = given_icon
		
func RemoveItem() -> void:
	item_name = ""
	is_empty = true
	slot_icon.texture = null
	slot_label.text = ""

func AssignAmountLabel() -> void:
	if amount != null and amount > 1:
		slot_label.text = "x" + str(amount)
	else:
		slot_label.text = ""
		
func SetItem(given_name: String, given_icon: Texture2D) -> void:
	AssignItem(given_name)
	AssignIcon(given_icon)
	AssignAmountLabel()

func _on_mouse_entered() -> void:
	if !is_focused: 
		SetHoveredStyle()

func _on_mouse_exited() -> void:
	if !is_focused: 
		SetNormalStyle()
	is_hovered = false

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		# Left click on slot being hovered on, but not currently focused on
		if !is_focused:
			SetFocusedStyle()
		
		# Left click on slot being focused on, disable the focus, return to hover
		else:
			SetHoveredStyle()
			release_focus()

func _on_focus_exited() -> void:
	RemoveFocusFromSlot()

func RemoveFocusFromSlot() -> void:
	SetNormalStyle()
	release_focus()

func SetNormalStyle() -> void:
	add_theme_stylebox_override("panel", get_theme_stylebox("normal", "OnInterfaceSlot"))
	is_focused = false; is_hovered = false
	
func SetHoveredStyle() -> void:
	add_theme_stylebox_override("panel", get_theme_stylebox("hovered", "OnInterfaceSlot"))
	is_focused = false; is_hovered = true
	
func SetFocusedStyle() -> void:
	add_theme_stylebox_override("panel", get_theme_stylebox("focused", "OnInterfaceSlot"))
	is_focused = true; is_hovered = false

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

func _can_drop_data(_at_position, data):
	return data != null
