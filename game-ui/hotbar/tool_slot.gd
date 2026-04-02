extends EquipmentSlot

@export var default_tool: DataTypes.Tools = DataTypes.Tools.Hoe
var current_tool: DataTypes.Tools
var is_equipped: bool = false

func _ready() -> void:
	super()
	ToolManager.SelectTool(default_tool)
	
func ChangeItem(item_num: int) -> void:
	current_item = items[item_num]
	
	# Tell tool manager which tool to store that it has switched to
	if current_item == "hoe": current_tool = DataTypes.Tools.Hoe
	elif current_item == "axe": current_tool = DataTypes.Tools.Axe
	elif current_item == "wateringcan": current_tool = DataTypes.Tools.WateringCan
		
	ToolManager.SelectTool(current_tool)

func UnequipSlot() -> void:
	if is_equipped:
		ToolManager.selected_tool = DataTypes.Tools.None
		is_equipped = false

func EquipSlot() -> void:
	if !is_equipped:
		if current_item == null: current_item = default_item
		ChangeItem(current_icon)
		is_equipped = true
