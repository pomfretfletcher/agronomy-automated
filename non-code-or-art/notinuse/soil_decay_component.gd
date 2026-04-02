class_name SoilDecayComponent
extends Node2D

@export var crop_watering_component: CropWateringComponent
@export var watered_soil_component: WateredSoilComponent
@export var crop_planting_component: CropPlantingComponent
@export var decay_chance: float = 0.1
@export var tilled_soil_tilemap_layer: TileMapLayer
@export var terrain_set: int = 0
@export var tilled_soil_terrain: int = 1

# Information
# Use - Internal
# By - Game Startup
# For - Initialises data
# Explanation -
#	Connects appropiate methods to time manager signals
# Debug - N/A
func _ready() -> void:
	TimeManager.day_passed.connect(DecayRandomSoil)

func DecayRandomSoil() -> void:
	for tile in WorldComponentData.tilled_tiles:
		# If tile not watered and there isnt a crop there, have a chance to decay each soil tile
		if tile not in WorldComponentData.planted_crops.keys() and tile not in WorldComponentData.watered_tiles:
			var is_removed = randf_range(0, 1) <= decay_chance
			if is_removed:
				tilled_soil_tilemap_layer.set_cells_terrain_connect([tile], 0, -1, true)
				WorldComponentData.tilled_tiles.erase(tile)
