extends EquipmentSlot

@export var default_seed: DataTypes.Seeds = DataTypes.Seeds.None
var current_seed: DataTypes.Seeds
var is_equipped: bool = false

func _ready() -> void:
	super()
	ToolManager.SelectSeed(default_seed, null)
	
func ChangeItem(item_num: int) -> void:
	current_item = items[item_num]
	
	# Tell tool manager which seed to store that it has switched to
	if current_item == "wheat_seed": current_seed = DataTypes.Seeds.Wheat
	elif current_item == "potato_seed": current_seed = DataTypes.Seeds.Potato
	elif current_item == "lettuce_seed": current_seed = DataTypes.Seeds.Lettuce
		
	var crop_scene = SeedCropDictionary.crop_scene_dictionary.get(current_seed)
	ToolManager.SelectSeed(current_seed, crop_scene)

func UnequipSlot() -> void:
	if is_equipped:
		ToolManager.selected_seed = DataTypes.Seeds.None
		is_equipped = false

func EquipSlot() -> void:
	if !is_equipped:
		if current_item == null: current_item = default_item
		ChangeItem(current_icon)
		
		is_equipped = true
