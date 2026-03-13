class_name LandTillingComponent
extends TileComponent

@export var tilled_soil_tilemap_layer: TileMapLayer
@export var terrain_set: int = 0
@export var tilled_soil_terrain: int = 1
@export var crop_planting_component: CropPlantingComponent

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("untill_soil"):
		if ToolManager.selected_tool == DataTypes.Tools.Hoe:
			GetCellInFrontOfPlayer()
			UntillSoil()
	elif event.is_action_pressed("use_tool"):
		if ToolManager.selected_tool == DataTypes.Tools.Hoe:
			GetCellInFrontOfPlayer()
			TillSoil()

func TillSoil() -> void:
	if cell_source_id != -1:
		tilled_soil_tilemap_layer.set_cells_terrain_connect([cell_position], terrain_set, tilled_soil_terrain, true)

func UntillSoil() -> void:
	tilled_soil_tilemap_layer.set_cells_terrain_connect([cell_position], 0, -1, true)
