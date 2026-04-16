class_name CropRemovalComponent
extends TileComponent

@export var crop_fields: Node2D


# Function Information
# Use - Crop Removing
# Does - Allows player to remove a crop in front of them
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("remove_crop"):
		if ToolManager.selected_equipment == DataTypes.Equipments.HOE:
			GetCellInFrontOfPlayer()
			RemoveCrop()


func RemoveCrop() -> void:
	var crop = WorldComponentData.planted_crops.get(cell_position)
	if crop:
		crop.queue_free()
		WorldComponentData.planted_crops.erase(cell_position)
