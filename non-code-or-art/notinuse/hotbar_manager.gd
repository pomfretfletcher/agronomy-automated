extends Node

# Stores name of each item in the player's hotbar
@export var preset_hotbar: Array[String]
@export var hotbar_limit = 9
var current_hotbar: Array[String]
var hotbar_equipment_slots: Array[String]
var hotbar_inventory_slots: Array[String]

# Information
# Use - Internal
# By - Game Startup
# For - Initialises data
# Explanation -
#	Setups initial hotbar list
# Debug - N/A
func _ready() -> void:
	current_hotbar = preset_hotbar
