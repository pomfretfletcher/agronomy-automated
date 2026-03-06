class_name CropPlantingComponent
extends MouseComponent

@export var crop_fields: Node2D

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("remove_crop"):
		if ToolManager.selected_tool == DataTypes.Tools.Hoe:
			GetTargetedCell()
			RemoveCrop()
			
	elif event.is_action_pressed("plant_seed"):
		if ToolManager.selected_seed != DataTypes.Seeds.None:
			GetTargetedCell()
			PlantCrop()
			
func PlantCrop() -> void:
	if distance < mouse_reach && cell_source_id != -1:
		var crop: Crop = ToolManager.selected_seed_crop_scene.instantiate()
		crop_fields.add_child(crop)
		crop.global_position = local_cell_position

func RemoveCrop() -> void:
	if distance < mouse_reach:
		var crop_nodes = crop_fields.get_children()
		
		for node: Node2D in crop_nodes:
			if node.global_position == local_cell_position:
				node.queue_free()
