extends Node

var grass_tiles: Array[Vector2i]
var planted_crops: Dictionary[Vector2i, Crop]
var watered_tiles: Array[Vector2i]
var tilled_tiles: Array[Vector2i]
var built_tiles: Dictionary[Vector2i, Building]

var grass_component: GrassHandlingComponent
var soil_component: SoilHandlingComponent
var watered_soil_component: WateredSoilComponent


func _ready() -> void:
	grass_component = get_tree().current_scene.find_child("GrassHandlingComponent", true, false)
	soil_component = get_tree().current_scene.find_child("SoilHandlingComponent", true, false)
	watered_soil_component = get_tree().current_scene.find_child("WateredSoilComponent", true, false)


func GetSaveData() -> Dictionary:
	var planted_crops_save_form = {}
	for tile_position in planted_crops.keys():
		planted_crops_save_form.set(tile_position, planted_crops[tile_position].internal_name)
	var built_tiles_save_form = {}
	for tile_position in built_tiles.keys():
		built_tiles_save_form.set(tile_position, built_tiles[tile_position].internal_name)
		
	var save_data = {
		"watered_tiles": watered_tiles,
		"tilled_tiles": tilled_tiles,
		"planted_crops": planted_crops_save_form,
		"grass_tiles": grass_tiles,
		"built_tiles": built_tiles_save_form,
	}
	return save_data


func ApplyLoadedData(loaded_save_data: Dictionary) -> void:
	var applied = ["watered_tiles", "tilled_tiles", "planted_crops", "grass_tiles", "built_tiles"]	
	SaveLoadManager.CheckLoadedDataIsValid(applied, loaded_save_data.keys(), self)
	
	RemoveCurrentData()
	if loaded_save_data.has("grass_tiles"): grass_tiles = gdExtensions.StringArrayToVector2iArray(loaded_save_data["grass_tiles"])
	if loaded_save_data.has("watered_tiles"): watered_tiles = gdExtensions.StringArrayToVector2iArray(loaded_save_data["watered_tiles"])
	if loaded_save_data.has("tilled_tiles"): tilled_tiles = gdExtensions.StringArrayToVector2iArray(loaded_save_data["tilled_tiles"])
	if loaded_save_data.has("planted_crops"): 
		var tiles = gdExtensions.StringArrayToVector2iArray(loaded_save_data["planted_crops"].keys())
		for tile_position in tiles:
			planted_crops.set(tile_position, null)
	if loaded_save_data.has("built_tiles"):
		var tiles = gdExtensions.StringArrayToVector2iArray(loaded_save_data["built_tiles"].keys())
		for tile_position in tiles:
			built_tiles.set(tile_position, null)
	SetupNewData()


func RemoveCurrentData() -> void:
	for crop in planted_crops.values():
		crop.queue_free()
	for building in built_tiles.values():
		building.queue_free()
	
	grass_component.EraseGrassTiles()
	soil_component.EraseSoilTiles()
	watered_soil_component.EraseWateredTiles()
	planted_crops.clear()
	built_tiles.clear()


func SetupNewData() -> void:
	grass_component.SetupGrassTiles()
	soil_component.SetupSoilTiles()
	watered_soil_component.SetupWateredTiles()
