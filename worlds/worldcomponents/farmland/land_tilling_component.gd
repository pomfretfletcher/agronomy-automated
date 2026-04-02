class_name LandTillingComponent
extends TileComponent

@export var tilled_soil_tilemap_layer: TileMapLayer
@export var terrain_set: int = 0
@export var tilled_soil_terrain: int = 1

func _unhandled_input(event: InputEvent) -> void:
	if !player.can_use_tools:
		return
		
	if event.is_action_pressed("untill_soil"):
		if ToolManager.selected_tool == DataTypes.Tools.Hoe:
			GetCellInFrontOfPlayer()
			UntillSoil()
	elif event.is_action_pressed("use_tool"):
		if ToolManager.selected_tool == DataTypes.Tools.Hoe:
			GetCellInFrontOfPlayer()
			TillSoil()

func TillSoil() -> void:
	if CanTillAt(cell_position):
		tilled_soil_tilemap_layer.set_cells_terrain_connect([cell_position], terrain_set, tilled_soil_terrain, true)
		if !WorldComponentData.tilled_tiles.has(cell_position):
			WorldComponentData.tilled_tiles.append(cell_position)
		
func UntillSoil() -> void:
	tilled_soil_tilemap_layer.set_cells_terrain_connect([cell_position], 0, -1, true)
	WorldComponentData.tilled_tiles.erase(cell_position)

func CanTillAt(tile_position: Vector2i) -> bool:
	var validity = (tile_position not in WorldComponentData.built_tiles.keys()) and (cell_source_id != -1)	
	return validity
