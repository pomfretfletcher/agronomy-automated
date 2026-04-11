extends EquipmentSlot

@export var default_seed: DataTypes.Seeds = DataTypes.Seeds.NONE
var current_seed: DataTypes.Seeds
var is_equipped: bool = false

func _ready() -> void:
	super()
	ToolManager.SelectSeed(default_seed, null)
	
func ChangeItem(item_num: int) -> void:
	current_item = items[item_num]
	
	# Tell tool manager which seed to store that it has switched to
	current_seed = Database.database[current_item].seed_enum
		
	var crop_scene = Database.database[Database.database[current_item].crop_name].crop_scene
	ToolManager.SelectSeed(current_seed, crop_scene)

func UnequipSlot() -> void:
	if is_equipped:
		ToolManager.selected_seed = DataTypes.Seeds.NONE
		is_equipped = false

func EquipSlot() -> void:
	if !is_equipped:
		if current_item == null: current_item = default_item
		ChangeItem(current_icon)
		
		is_equipped = true
