class_name Crop
extends Node2D

@export var sprite_2d: Sprite2D
@export var crop_growth_component: CropGrowthComponent

@export var crop_name: String
var dropped_item_framework: PackedScene = ReusedPackedSceneDictionary.packed_scene_dictionary["item_framework"]
@export var dropped_item_name: String

var is_watered: bool = false
@export var water_retention_days: int = 1
var days_until_water_reset: int

# Information
# Use - Internal
# By - Game Startup
# For - Initialises data
# Explanation -
#	Sets initial water retention length value 
# Debug - N/A
func _ready() -> void:
	days_until_water_reset = water_retention_days
		
func OnWater() -> void:
	is_watered = true
	days_until_water_reset = water_retention_days

func OnHarvest() -> bool:
	if crop_growth_component.growth_progress >= crop_growth_component.growth_total:
		var item_instance = dropped_item_framework.instantiate() as Item
		item_instance.global_position = global_position
		item_instance.ChangeItemName(dropped_item_name)
		item_instance.ChangeItemSprite(NameTextureDictionary.texture_dictionary.get(dropped_item_name))
		get_parent().get_parent().add_child(item_instance)
		queue_free()
		return true
	else:
		return false
