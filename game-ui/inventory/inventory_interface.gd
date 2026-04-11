class_name InventoryInterface
extends UserInterface

@export var hotbar_interface: HotbarInterface

# Function Information
# Use - Interface Use, Inventory
# Does - Gets needed frameworks for constructing interface, then calls for interface to be setup
# Debug - N/A
func _ready() -> void:
	slot_framework = ReusedPackedSceneDictionary.packed_scene_dictionary["inventory_slot_framework"]
	row_framework = ReusedPackedSceneDictionary.packed_scene_dictionary["inventory_row_framework"]
	call_deferred("SetupInterface")
	hotbar_interface.slot_item_assignment_component = slot_item_assignment_component

# Function Information
# Use - Interface Use, Inventory
# Does - Allows player to open inventory
# Debug - N/A
func _unhandled_input(event: InputEvent) -> void:
	if lock_open_close:
		return
		
	if event.is_action_pressed("open_and_close_inventory"):
		if is_opened:
			CloseInterface()
		else:
			OpenInterface()

func GetSaveData() -> Dictionary:
	var save_data = {
		"current_contents": slot_item_assignment_component.current_contents,
		"current_slots": GetSlotReferences(),
		"internal_name": internal_name,
	}
	return save_data

func ApplyLoadedData(loaded_save_data: Dictionary) -> void:
	var applied = ["current_contents", "current_slots"]	
	SaveLoadManager.CheckLoadedDataIsValid(applied, loaded_save_data.keys(), self)
	
	if loaded_save_data.has("current_contents"): 
		var slotcomp = slot_item_assignment_component
		var loaded_dict = loaded_save_data["current_contents"]
		for key in loaded_dict.keys():
			slotcomp.current_contents[key] = loaded_dict[key]
	if loaded_save_data.has("current_slots"):
		call_deferred("SetupLoadedSlots", loaded_save_data)
	
func SetupLoadedSlots(loaded_save_data: Dictionary) -> void:
	var reference_array = loaded_save_data["current_slots"]
	if gdExtensions.IsArray2D(reference_array):
		for row_index in range(len(reference_array)):
			for col_index in range(len(reference_array[row_index])):
				if reference_array[row_index][col_index] != "":
					var slot = slot_item_assignment_component.current_slots[row_index][col_index] as InterfaceSlot
					slot.SetItem(reference_array[row_index][col_index])
