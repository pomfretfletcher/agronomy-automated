class_name CropPlantingComponent
extends TileComponent

@export var crop_fields: Node2D


# Function Information
# Use - Crop Planting
# Does - Allows player to plant a crop in front of them
func _unhandled_input(event: InputEvent) -> void:
	if !player.can_plant:
		return

	if event.is_action_pressed("plant_seed"):
		if ToolManager.selected_seed != DataTypes.Seeds.NONE:
			GetCellInFrontOfPlayer()
			PlantCrop()


func PlantCrop() -> void:
	if CanPlantAt(cell_position):
		# Create a crop at the cell position
		var crop: Crop = ToolManager.selected_seed_crop_scene.instantiate() as Crop
		crop_fields.add_child(crop)
		crop.global_position = local_cell_position
		crop.tilemap_cell_position = cell_position
		WorldComponentData.planted_crops[cell_position] = crop
		
		# Ensures crops planted into already watered soil is treat as watered
		if WorldComponentData.watered_tiles.has(cell_position):
			crop.is_watered = true


func CanPlantAt(tile_position: Vector2i) -> bool:
	var validity = (tile_position not in WorldComponentData.built_tiles.keys()) and (tile_position not in WorldComponentData.planted_crops.keys()) and (cell_source_id != -1)	
	return validity
