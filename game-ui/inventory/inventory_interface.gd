class_name InventoryInterface
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
	slot_framework = ReusedPackedSceneDictionary.packed_scene_dictionary["inventory_slot_framework"]
	row_framework = ReusedPackedSceneDictionary.packed_scene_dictionary["inventory_row_framework"]
	call_deferred("SetupInterface")

func _unhandled_input(event: InputEvent) -> void:
	if lock_open_close:
		return
		
	if event.is_action_pressed("open_and_close_inventory"):
		if is_opened:
			CloseInterface()
		else:
			OpenInterface()
