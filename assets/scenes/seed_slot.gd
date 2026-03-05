extends Slot

@export var default_seed: DataTypes.Seeds = DataTypes.Seeds.Wheat

func _ready() -> void:
	ToolManager.SelectSeed(default_seed)
	
func ChangeItem(item_num: int) -> void:
	current_item = items[item_num]
	
	var seed: DataTypes.Seeds
	
	# Tell tool manager which seed to store that it has switched to
	if current_item == "wheatseed":
		seed = DataTypes.Seeds.Wheat
	elif current_item == "potatoseed":
		seed = DataTypes.Seeds.Potato
	elif current_item == "lettuceseed":
		seed = DataTypes.Seeds.Lettuce
		
	ToolManager.SelectSeed(seed)
