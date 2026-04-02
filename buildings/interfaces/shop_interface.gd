class_name ShopInterface
extends Interface

# Information
# Use - Internal
# By - Game Startup
# For - Initialises data
# Explanation -
#	Grabs packed scenes used for creating new rows and slots
#	Calls setup interface method next frame (so all data needed for it is ready)
# Debug - N/A
func _ready() -> void:
	slot_framework = ReusedPackedSceneDictionary.packed_scene_dictionary["shop_slot_framework"]
	row_framework = ReusedPackedSceneDictionary.packed_scene_dictionary["shop_row_framework"]
	call_deferred("SetupInterface")
