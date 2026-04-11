extends EquipmentSlot

@export var default_equipment: DataTypes.Equipments = DataTypes.Equipments.HOE
var current_equipment: DataTypes.Equipments
var is_equipped: bool = false

func _ready() -> void:
	super()
	ToolManager.SelectEquipment(default_equipment)
	
func ChangeItem(item_num: int) -> void:
	current_item = items[item_num]
	
	# Tell tool manager which equipment to store that it has switched to
	if current_item == "hoe": current_equipment = DataTypes.Equipments.HOE
	elif current_item == "axe": current_equipment = DataTypes.Equipments.AXE
	elif current_item == "wateringcan": current_equipment = DataTypes.Equipments.WATERING_CAN
		
	ToolManager.SelectEquipment(current_equipment)

func UnequipSlot() -> void:
	if is_equipped:
		ToolManager.selected_equipment = DataTypes.Equipments.NONE
		is_equipped = false

func EquipSlot() -> void:
	if !is_equipped:
		if current_item == null: current_item = default_item
		ChangeItem(current_icon)
		is_equipped = true
