class_name CropPlantingComponent
extends TileComponent

@export var crop_fields: Node2D

func _unhandled_input(event: InputEvent) -> void:
	if !player.can_plant:
		return
		
	if event.is_action_pressed("remove_crop"):
		if ToolManager.selected_tool == DataTypes.Tools.Hoe:
			GetCellInFrontOfPlayer()
			RemoveCrop()
			
	elif event.is_action_pressed("plant_seed"):
		if ToolManager.selected_seed != DataTypes.Seeds.None:
			GetCellInFrontOfPlayer()
			PlantCrop()
			
func PlantCrop() -> void:
	if CanPlantAt(cell_position):
		# Create a crop at the cell position
		var crop: Crop = ToolManager.selected_seed_crop_scene.instantiate() as Crop
		crop_fields.add_child(crop)
		crop.global_position = local_cell_position
		WorldComponentData.planted_crops[cell_position] = crop
		
		# Ensures crops planted into already watered soil is treat as watered
		if WorldComponentData.watered_tiles.has(cell_position):
			crop.is_watered = true
	
func RemoveCrop() -> void:
	var crop_nodes = crop_fields.get_children()
		
	for node: Node2D in crop_nodes:
		if node.global_position == local_cell_position:
			node.queue_free()

func CanPlantAt(tile_position: Vector2i) -> bool:
	var validity = (tile_position not in WorldComponentData.built_tiles.keys()) and (tile_position not in WorldComponentData.planted_crops.keys()) and (cell_source_id != -1)	
	return validity
