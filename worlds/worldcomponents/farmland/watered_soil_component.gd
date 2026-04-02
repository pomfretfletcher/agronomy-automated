class_name WateredSoilComponent
extends Node2D

@export var watered_soil_tilemap_layer: TileMapLayer
@export var tilled_soil_tilemap_layer: TileMapLayer
@export var terrain_set: int = 0
@export var watered_soil_terrain: int = 2

# Information
# Use - Internal
# By - Game Startup
# For - Initialises data
# Explanation -
#	Connects internal function to time manager day passed signal
# Debug - N/A
func _ready() -> void:
	TimeManager.day_passed.connect(ResetTileWateredStatus)
	
func ResetTileWateredStatus() -> void:
	for tile in WorldComponentData.watered_tiles:
		if tile not in WorldComponentData.planted_crops.keys():
			WorldComponentData.watered_tiles.erase(tile)
			watered_soil_tilemap_layer.set_cells_terrain_connect([tile], 0, -1, true)		
		else:
			var crop = WorldComponentData.planted_crops[tile]
			if crop.days_until_water_reset == 1:
				crop.is_watered = false
				crop.days_until_water_reset = crop.water_retention_days
				WorldComponentData.watered_tiles.erase(tile)
				watered_soil_tilemap_layer.set_cells_terrain_connect([tile], 0, -1, true)
			else:
				crop.days_until_water_reset -= 1

func WaterTile(tile_position: Vector2i) -> void:
	var cell_source_id = tilled_soil_tilemap_layer.get_cell_source_id(tile_position)
	if cell_source_id != -1:
		WorldComponentData.watered_tiles.append(tile_position)
		watered_soil_tilemap_layer.set_cells_terrain_connect([tile_position], terrain_set, watered_soil_terrain, true)
