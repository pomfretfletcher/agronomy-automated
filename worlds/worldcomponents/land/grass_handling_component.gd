class_name GrassHandlingComponent
extends Node

@export var grass_tilemap_layer: TileMapLayer
@export var terrain_set: int = 0
@export var grass_terrain: int = 0


func _ready() -> void:
	WorldComponentData.grass_tiles = grass_tilemap_layer.get_used_cells()


func EraseGrassTiles() -> void:
	gdExtensions.ClearTileMapLayer(grass_tilemap_layer)
	WorldComponentData.grass_tiles.clear()


func SetupGrassTiles() -> void:
	grass_tilemap_layer.set_cells_terrain_connect(WorldComponentData.grass_tiles, terrain_set, grass_terrain)	
