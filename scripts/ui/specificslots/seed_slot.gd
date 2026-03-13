extends EquipmentSlot

@export var default_seed: DataTypes.Seeds = DataTypes.Seeds.None

func _ready() -> void:
	super._ready()
	ToolManager.SelectSeed(default_seed, null)
	
func ChangeItem(item_num: int) -> void:
	current_item = items[item_num]
	
	var seed: DataTypes.Seeds
	var crop_scene
	
	# Tell tool manager which seed to store that it has switched to
	if current_item == "wheat_seed":
		seed = DataTypes.Seeds.Wheat
	elif current_item == "potato_seed":
		seed = DataTypes.Seeds.Potato
	elif current_item == "lettuce_seed":
		seed = DataTypes.Seeds.Lettuce
		
	crop_scene = SeedCropDictionary.crop_scene_dictionary.get(seed)
	ToolManager.SelectSeed(seed, crop_scene)

func UnequipSlot() -> void:
	ToolManager.selected_seed = DataTypes.Seeds.None

func EquipSlot() -> void:
	if current_item == null:
		current_item = default_item
		ChangeItem(current_icon)
	else:
		ChangeItem(current_icon)
