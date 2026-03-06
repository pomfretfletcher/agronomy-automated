extends PanelContainer

@onready var wheat_label: Label = $MarginContainer/VBoxContainer/Wheat/MarginContainer/Label
@onready var potato_label: Label = $MarginContainer/VBoxContainer/Potato/MarginContainer/Label
@onready var lettuce_label: Label = $MarginContainer/VBoxContainer/Lettuce/MarginContainer/Label

func _ready() -> void:
	InventoryManager.inventory_changed.connect(UpdateInventoryLabels)

func UpdateInventoryLabels():
	if InventoryManager.inventory.has("wheat"):
		wheat_label.text = str(InventoryManager.inventory["wheat"])
	else:
		wheat_label.text = "0"
	if InventoryManager.inventory.has("potato"):
		potato_label.text = str(InventoryManager.inventory["potato"])
	else:
		potato_label.text = "0"
	if InventoryManager.inventory.has("lettuce"):
		lettuce_label.text = str(InventoryManager.inventory["lettuce"])
	else:
		lettuce_label.text = "0"
