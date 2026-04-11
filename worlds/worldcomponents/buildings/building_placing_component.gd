class_name BuildingPlacingComponent
extends TileComponent

@export var buildings: Node2D
@export var ui: CanvasLayer

# Function Information
# Use - Building Placing
# Does - If under correct situation, place building in front of player
# Debug - N/A
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action("place_building"):
		if ToolManager.selected_building != "":
			GetCellInFrontOfPlayer()
			PlaceBuilding()

func PlaceBuilding() -> void:
	if ToolManager.selected_building == "":
		return
	
	if CanBuild():
		var building_data = Database.database[Database.database[ToolManager.selected_building].building_name] as BuildingData
		var building = building_data.building_scene.instantiate() as Building
		buildings.add_child(building)
		building.global_position = local_cell_position
		building.tilemap_cell_position = cell_position
		WorldComponentData.built_tiles[cell_position] = building
		
		var interface_data = Database.database[building_data.interface_name] as InterfaceData
		var interface = interface_data.interface_scene.instantiate() as BuildingInterface
		ui.add_child(interface)
		building.interface = interface
		interface.associated_building = building
		interface.hide()

func CanBuild() -> bool:
	return cell_position not in WorldComponentData.built_tiles.keys() and player.can_build
