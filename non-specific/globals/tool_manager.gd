extends Node

var selected_equipment: DataTypes.Equipments = DataTypes.Equipments.NONE
var selected_seed: DataTypes.Seeds = DataTypes.Seeds.NONE
var selected_building: String
var selected_resource: String
var selected_seed_crop_scene

func GetSaveData() -> Dictionary:
	var save_data = {
		"selected_equipment": selected_equipment,
		"selected_seed": selected_seed,
		"selected_resource": selected_resource,
		"selected_building": selected_building,
	}
	return save_data

func ApplyLoadedData(loaded_save_data: Dictionary) -> void:
	var applied = ["selected_equipment", "selected_seed", "selected_resource", "selected_building"]	
	SaveLoadManager.CheckLoadedDataIsValid(applied, loaded_save_data.keys(), self)

	if loaded_save_data.has("selected_equipment"): selected_equipment  = loaded_save_data["selected_equipment"]
	if loaded_save_data.has("selected_seed"): 
		selected_seed = loaded_save_data["selected_seed"]
		selected_seed_crop_scene = Database.GetCropScene(selected_seed)
	if loaded_save_data.has("selected_resource"): selected_resource = loaded_save_data["selected_resource"]
	if loaded_save_data.has("selected_building"): selected_building = loaded_save_data["selected_building"]
	
func EquipTool(tool: String) -> void:
	UnequipAllTools()
	
	if Database.database[tool].item_type == DataTypes.ItemTypes.EQUIPMENT:
		var to_equip = Database.database[tool].equipment_enum
		selected_equipment = to_equip
		
	elif Database.database[tool].item_type == DataTypes.ItemTypes.SEED:
		var to_equip = Database.database[tool].seed_enum
		selected_seed = to_equip
		selected_seed_crop_scene = Database.GetCropScene(selected_seed)
		
	elif Database.database[tool].item_type == DataTypes.ItemTypes.RAW_RESOURCE:
		selected_resource = tool
		
	elif Database.database[tool].item_type == DataTypes.ItemTypes.BUILDING:
		selected_building = tool
		
func UnequipAllTools() -> void:
	selected_equipment = DataTypes.Equipments.NONE
	selected_seed = DataTypes.Seeds.NONE
	selected_seed_crop_scene = null
	selected_resource = ""
	selected_building = ""
