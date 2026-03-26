class_name CropWateringComponent
extends TileComponent

@export var watered_soil_component: WateredSoilComponent

func _unhandled_input(event: InputEvent) -> void:
	if !player.can_use_tools:
		return
		
	if event.is_action_pressed("use_tool"):
		if ToolManager.selected_tool == DataTypes.Tools.WateringCan:
			GetCellInFrontOfPlayer()
			WaterCrop()

func WaterCrop() -> void:
	if WorldComponentData.planted_crops.has(cell_position):
		WorldComponentData.planted_crops[cell_position].OnWater()
	if cell_position not in WorldComponentData.watered_tiles:
		watered_soil_component.WaterTile(cell_position)
