class_name SoilUntillingComponent
extends TileComponent

@export var tilled_soil_tilemap_layer: TileMapLayer


# Function Information
# Use - Soil Untilling
# Does - Allows player to untill the land in front of them
func _unhandled_input(event: InputEvent) -> void:
	if !player.can_use_equipment:
		return
		
	if event.is_action_pressed("untill_soil"):
		if ToolManager.selected_equipment == DataTypes.Equipments.HOE:
			GetCellInFrontOfPlayer()
			UntillSoil()


func UntillSoil() -> void:
	tilled_soil_tilemap_layer.set_cells_terrain_connect([cell_position], 0, -1, true)
	WorldComponentData.tilled_tiles.erase(cell_position)
	
	var crop = WorldComponentData.planted_crops.get(cell_position)
	if crop:
		crop.queue_free()
		WorldComponentData.planted_crops.erase(cell_position)
