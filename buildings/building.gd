class_name Building
extends Node2D

@export var internal_name: String
@export var interface_handler: InterfaceHandler
var tilemap_cell_position: Vector2i
@onready var player: Player = get_tree().get_first_node_in_group("player")


# Function Information
# Use - Building Interaction
# Does - Sets up interface and variables for the player to be able to interact with this building
func InteractWith() -> void:
	if player.can_interact:
		WorldComponentData.menu_manager.OpenInterfaceInteractionTab(interface_handler)


# Function Information
# Use - Building Interaction
# Does - Hides interface and reverts variables used for interaction
func UninteractWith() -> void:
	pass


func GetSaveData() -> Dictionary:
	var save_data = {
		"tilemap_cell_position_x": tilemap_cell_position.x,
		"tilemap_cell_position_y": tilemap_cell_position.y,
		"global_position_x": global_position.x,
		"global_position_y": global_position.y,
	}
	var interface_save_data = interface_handler.GetSaveData()
	for entry in interface_save_data:
		save_data.set(entry, interface_save_data[entry])
	return save_data


func ApplyLoadedData(loaded_save_data: Dictionary) -> void:
	var applied = ["tilemap_cell_position_x", "tilemap_cell_position_y", "global_position_x", "global_position_y", "slot_items", "slot_amounts"]	
	SaveLoadManager.CheckLoadedDataIsValid(applied, loaded_save_data.keys(), self)
	
	if loaded_save_data.has("global_position_x"): global_position = Vector2(loaded_save_data["global_position_x"], loaded_save_data["global_position_y"])
	if loaded_save_data.has("tilemap_cell_position_x"): tilemap_cell_position = Vector2i(loaded_save_data["tilemap_cell_position_x"], loaded_save_data["tilemap_cell_position_y"])
	
	for entry in ["tilemap_cell_position_x", "tilemap_cell_position_y", "global_position_x", "global_position_y"]:
		loaded_save_data.erase(entry)
	interface_handler.ApplyLoadedData(loaded_save_data)
