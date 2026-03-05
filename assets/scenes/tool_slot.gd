extends Slot

@export var default_tool: DataTypes.Tools = DataTypes.Tools.Hoe

func _ready() -> void:
	ToolManager.SelectTool(default_tool)
	
func ChangeItem(item_num: int) -> void:
	current_item = items[item_num]
	
	var tool: DataTypes.Tools
	
	# Tell tool manager which tool to store that it has switched to
	if current_item == "hoe":
		tool = DataTypes.Tools.Hoe
	elif current_item == "axe":
		tool = DataTypes.Tools.Axe
	elif current_item == "wateringcan":
		tool = DataTypes.Tools.WateringCan
		
	ToolManager.SelectTool(tool)
