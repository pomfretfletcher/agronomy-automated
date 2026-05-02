class_name Crop
extends Node2D

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var crop_growth_component: CropGrowthComponent = $CropGrowthComponent
@onready var crop_sway_component: CropSwayComponent = $CropSwayComponent

@export var internal_name: String

var is_watered: bool = false
var days_until_water_reset: int
var tilemap_cell_position: Vector2i
var crop_data: CropData


# Function Information
# Use - Crop Growth/Watering/Harvest
# Does - Grabs data for crop, sets starting variables for watering
func _ready() -> void:
	crop_data = Database.database[internal_name] as CropData
	days_until_water_reset = crop_data.water_retention_days


# Function Information
# Use - Crop Watering
# Does - Sets internal state to being watered and resets how long left until must be watered again
func OnWater() -> void:
	is_watered = true
	days_until_water_reset = crop_data.water_retention_days


# Function Information
# Use - Crop Harvest
# Does - If able to be harvested, create an item at current position
func OnHarvest() -> bool:
	if crop_growth_component.growth_progress >= crop_growth_component.growth_total:
		# Get and instantiate framework for item
		var item_instance = ReusedPackedSceneDictionary.item_framework.instantiate() as ItemPickup
		
		# Set data for item
		item_instance.ChangeItemName(crop_data.item_name)
		item_instance.ChangeItemSprite(Database.database[crop_data.item_name].texture)
		
		# Set position and parent item to scene
		get_tree().current_scene.add_child(item_instance)
		item_instance.global_position = global_position
		
		# Delete self and return that harvest worked correctly
		queue_free()
		return true
	else:
		return false


func GetSaveData() -> Dictionary:
	var save_data = {
		"is_watered": is_watered,
		"days_until_water_reset": days_until_water_reset,
		"global_position_x": global_position.x,
		"global_position_y": global_position.y,
		"growth_total": crop_growth_component.growth_total,
		"growth_progress": crop_growth_component.growth_progress,
		"tilemap_cell_position_x": tilemap_cell_position.x,
		"tilemap_cell_position_y": tilemap_cell_position.y,
		"current_degree": crop_sway_component.current_degree,
		"sway_direction": crop_sway_component.sway_direction,
	}
	return save_data


func ApplyLoadedData(loaded_save_data: Dictionary) -> void:
	var applied = ["is_watered", "days_until_water_reset", "global_position_x", "global_position_y", "tilemap_cell_position_x", "tilemap_cell_position_y", "growth_total", "growth_progress", "current_degree", "sway_direction"]	
	SaveLoadManager.CheckLoadedDataIsValid(applied, loaded_save_data.keys(), self)
	
	if loaded_save_data.has("is_watered"): is_watered = loaded_save_data["is_watered"]
	if loaded_save_data.has("days_until_water_reset"): days_until_water_reset = loaded_save_data["days_until_water_reset"]
	if loaded_save_data.has("global_position_x"): global_position = Vector2(loaded_save_data["global_position_x"], loaded_save_data["global_position_y"])
	if loaded_save_data.has("tilemap_cell_position_x"): tilemap_cell_position = Vector2i(loaded_save_data["tilemap_cell_position_x"], loaded_save_data["tilemap_cell_position_y"])
	if loaded_save_data.has("growth_total"): crop_growth_component.growth_total = loaded_save_data["growth_total"]
	if loaded_save_data.has("growth_progress"): crop_growth_component.growth_progress = loaded_save_data["growth_progress"]
	if loaded_save_data.has("current_degree"): crop_sway_component.current_degree = loaded_save_data["current_degree"]
	if loaded_save_data.has("sway_direction"): crop_sway_component.sway_direction = loaded_save_data["sway_direction"]
