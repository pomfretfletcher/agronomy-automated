class_name Building
extends Node2D

@export var internal_name: String
@export var interface: Interface
var inventory_interaction_component: InventoryInteractionComponent
var tilemap_cell_position: Vector2i
var being_interacted_with: bool = false

func interact_with() -> void:
	if not being_interacted_with:
		inventory_interaction_component.OpenInterfaces(interface)
		being_interacted_with = true
	
func uninteract_with() -> void:
	if being_interacted_with:
		inventory_interaction_component.CloseInterfaces()
		being_interacted_with = false

func GetSaveData() -> Dictionary:
	var save_data = {
		"tilemap_cell_position_x": tilemap_cell_position.x,
		"tilemap_cell_position_y": tilemap_cell_position.y,
		"global_position_x": global_position.x,
		"global_position_y": global_position.y,
		"current_contents": interface.slot_item_assignment_component.current_contents,
		"current_slots": interface.GetSlotReferences(),
		"internal_name": internal_name,
	}
	return save_data

func ApplyLoadedData(loaded_save_data: Dictionary) -> void:
	var applied = ["tilemap_cell_position_x", "tilemap_cell_position_y", "global_position_x", "global_position_y", "current_contents", "current_slots"]	
	SaveLoadManager.CheckLoadedDataIsValid(applied, loaded_save_data.keys(), self)
	
	if loaded_save_data.has("global_position_x"): global_position = Vector2(loaded_save_data["global_position_x"], loaded_save_data["global_position_y"])
	if loaded_save_data.has("tilemap_cell_position_x"): tilemap_cell_position = Vector2i(loaded_save_data["tilemap_cell_position_x"], loaded_save_data["tilemap_cell_position_y"])
	if loaded_save_data.has("current_contents"): 
		var slotcomp = interface.slot_item_assignment_component
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
					var slot = interface.slot_item_assignment_component.current_slots[row_index][col_index] as InterfaceSlot
					slot.SetItem(reference_array[row_index][col_index])
