extends Slot

@export var default_seed: DataTypes.Seeds = DataTypes.Seeds.None

func _ready() -> void:
	super._ready()
	ToolManager.SelectSeed(default_seed, null)
	
func ChangeItem(item_num: int) -> void:
	current_item = items[item_num]
	
	var seed: DataTypes.Seeds
	var crop_scene
	
	# Tell tool manager which seed to store that it has switched to
	if current_item == "wheatseed":
		seed = DataTypes.Seeds.Wheat
		crop_scene = preload("res://scenes/objects/wheat_crop.tscn")
	elif current_item == "potatoseed":
		seed = DataTypes.Seeds.Potato
		crop_scene = preload("res://scenes/objects/potato_crop.tscn")
	elif current_item == "lettuceseed":
		seed = DataTypes.Seeds.Lettuce
		crop_scene = preload("res://scenes/objects/lettuce_crop.tscn")
		
	ToolManager.SelectSeed(seed, crop_scene)

func UnequipSlot() -> void:
	ToolManager.selected_seed = DataTypes.Seeds.None

func EquipSlot() -> void:
	if current_item == null:
		current_item = default_item
		ChangeItem(current_icon)
	else:
		ChangeItem(current_icon)
