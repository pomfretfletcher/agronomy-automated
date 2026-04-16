class_name CropHarvestComponent
extends MouseComponent

@export var crop_fields: Node2D


# Function Information
# Use - Crop Harvesting
# Does - If under correct situation, harvest cell under mouse
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("harvest_crop"):
		GetTargetedCell()
		HarvestCrop()


func HarvestCrop() -> void:
	if distance > mouse_reach:
		return
		
	for crop_position in WorldComponentData.planted_crops.keys():
		if crop_position == cell_position:
			var crop = WorldComponentData.planted_crops[crop_position]
			var harvested = crop.OnHarvest()
			if harvested:
				WorldComponentData.planted_crops.erase(cell_position)
