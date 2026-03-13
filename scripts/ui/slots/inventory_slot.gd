class_name InventorySlot
extends Slot

var item_name: String

func _ready() -> void:
	add_theme_stylebox_override("panel", theme.get_stylebox("normal", "ToolPanel"))
	InventoryManager.inventory_changed.connect(AssignAmountLabel)
	
func AssignItem(given_name: String) -> void:
	item_name = given_name
	
func AssignIcon(icon: Texture2D) -> void:
	var slot_icon: TextureRect = $MarginContainer/Icon
	slot_icon.texture = icon

func AssignAmountLabel() -> void:
	var amount = InventoryManager.inventory.get(item_name)
	var label: Label = $Label
	if amount > 1:
		label.text = "x" + str(amount)
