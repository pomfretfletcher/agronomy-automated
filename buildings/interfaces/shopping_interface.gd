class_name ShopInterface
extends BuildingInterface


# Function Information
# Use - Interface Use, Item Shopping
# Does - Gets needed frameworks for constructing interface, then calls for interface to be setup
func _ready() -> void:
	slot_framework = ReusedPackedSceneDictionary.packed_scene_dictionary["shop_slot_framework"]
	row_framework = ReusedPackedSceneDictionary.packed_scene_dictionary["shop_row_framework"]
	call_deferred("SetupInterface")


func SetupInitialData() -> void:
	if len(associated_building.starting_inventory) > 0:
		associated_building.ConstructStartingInventory()
