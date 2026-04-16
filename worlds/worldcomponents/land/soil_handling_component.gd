class_name SoilHandlingComponent
extends Node

@export var tilled_soil_tilemap_layer: TileMapLayer
@export var terrain_set: int = 0
@export var tilled_soil_terrain: int = 1


func EraseSoilTiles() -> void:
	gdExtensions.ClearTileMapLayer(tilled_soil_tilemap_layer)
	WorldComponentData.tilled_tiles.clear()


func SetupSoilTiles() -> void:
	tilled_soil_tilemap_layer.set_cells_terrain_connect(WorldComponentData.tilled_tiles, terrain_set, tilled_soil_terrain)	
