class_name StorageInterface
extends BuildingInterface


# Function Information
# Use - Interface Use, Item Storage
# Does - Gets needed frameworks for constructing interface, then calls for interface to be setup
func _ready() -> void:
	slot_framework = ReusedPackedSceneDictionary.packed_scene_dictionary["storage_slot_framework"]
	row_framework = ReusedPackedSceneDictionary.packed_scene_dictionary["storage_row_framework"]
	call_deferred("SetupInterface")
