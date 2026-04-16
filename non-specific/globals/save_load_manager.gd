extends Node

var not_saveable: bool = true

var save_data_component: SaveDataComponent
var save_data: Dictionary

var globals: Array
var globals_as_strings: Array
var root: Node
var crop_fields: Node2D
var buildings: Node2D
var interface_ui: CanvasLayer
var inventory_interface: InventoryInterface
var hotbar_interface: HotbarInterface

const SAVE_PATH =  "res://savegame.json"

var can_save: bool = true
var can_load: bool = true


func ToggleSaveLoad(mode: String) -> void:
	if mode == "unlock":
		can_save = true
		can_load = true
	elif mode == "lock":
		can_save = false
		can_load = false
	else:
		print("Invalid input into toggle save load method.")


# Function Information
# Use - Saving/Loading Game Data
# Does - Obtains all references for nodes that will need to be saved, or parent nodes for saveable
#		game components
func _ready() -> void:
	var globals_and_root = get_tree().current_scene.get_parent().get_children()
	globals_and_root.erase(get_tree().current_scene)
	globals = globals_and_root
	root = get_tree().current_scene
	for global in globals:
		globals_as_strings.append(global.name)
	
	# Access nodes that will be loaded and saved and kept between instances
	crop_fields = gdExtensions.GetChildByName(root, "CropFields")
	buildings = gdExtensions.GetChildByName(root, "Buildings")
	interface_ui = gdExtensions.GetChildByName(root, "InterfaceUI")
	inventory_interface = gdExtensions.GetChildByName(root, "InventoryInterface")
	hotbar_interface = gdExtensions.GetChildByName(root, "HotbarInterface")


# Placeholder Function
func _unhandled_input(event: InputEvent) -> void:
	# Placeholder methods - will make into menu called methods
	if event.is_action_pressed("test_save") and can_save:
		SaveData()
	elif event.is_action_pressed("test_load") and can_load:
		LoadData()


# Function Information
# Use - Saving/Loading Game Data
# Does - Gets and saves data of all components of the game
# Debug - Error Statements
#		Identify and flag issues with save processe
func SaveData() -> void:
	# Get save data of global scripts/nodes
	for global in globals:
		global = global as Node
		# Future proof print to ensure globals are properly formatted for being saved or not
		if !global.has_method("GetSaveData") and global.get("not_saveable") == null:
			print("Error saving data of " + str(global) + ", it is missing GetSaveData method or is not marked as not-saveable.")
		elif global.has_method("GetSaveData"):
			save_data.set(global.name, global.call("GetSaveData"))
	
	# Dict used for storing multiple of same type - stores amount of each node type saved in the data
	var saveable_entries: Dictionary[String, int]
	for saveable in get_tree().get_nodes_in_group("has_save_data"):
		save_data_component = gdExtensions.GetImmediateChildOfType("SaveDataComponent", saveable)
		if saveable.get("internal_name"):
			var internal_name = saveable.internal_name
			# Decides the entry key for the saveable object based on its internal name
			# and how many of that internal name are being saved
			if saveable_entries.has(internal_name):
				saveable_entries[internal_name] += 1
			else:
				saveable_entries.set(internal_name, 0)
			
			var entry_key = internal_name + str(saveable_entries[internal_name])
			var data = save_data_component.call("GetSaveData")
			
			if saveable.is_in_group("persisting_node"):
				data.set("persisting_node", true)
				
			if data.has("internal_name"):
				save_data.set(entry_key, data)
			else:
				# Future proof error - Allow developer to not miss why data not being saved
				print("Error saving node " + str(saveable) + ", it has an internal name variable but is not saving it.")
		else:
			# Future proof error - Allow developer to not miss why data not being saved
			print("Error saving node " + str(saveable) + ", is it lacking an internal name variable.")	
	
	# Saves produced save data in a human-ish readable format. Allows for debugging and error analysis
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	file.store_string(FormatJSON(save_data))
	file.close()


# Function Information
# Use - Saving/Loading Game Data
# Does - Loads and applies data to all components of the game
# Debug - Error Statements
#		Identify and flag issues with load processe
func LoadData() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		return
	
	# Open and read json file of save data
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	save_data = JSON.parse_string(file.get_as_text())
	file.close()
	
	var null_entries: Array[String]
	for entry_key in save_data:
		# Remove all entries that have missing data
		if save_data[entry_key] == null:
			print("Error loading save data of " + entry_key + ", its data dictionary is null.")
			null_entries.append(entry_key)
	for entry in null_entries:
		save_data.erase(entry)
	
	# Applies loaded data in specific ways for different parts of the game
	ApplyLoadedGlobalData()
	AssembleCropFields()
	SetupBuildings()
	LoadUserInterfaces()
	
	var applied_customly = ["inventory_interface", "hotbar_interface"]
	""" Need to change following as it applies only really to persist nodes, must construct a persist
		id sort of thing? Some way to identify different persist nodes from each other and apply their data.
		Also, must make sure perissted nodes like buildings have tilemap cell position data inserted into
		them throuhgh the persist save component. Could then use this as a way to load data for persist
		components, by referencing their internal tilemap cell position and possibly parent later on should
		we be able to place multiple on same tile.
	"""
	# For all nodes in the game that do not have a specific pre emptive for applying save data
	for saveable in get_tree().get_nodes_in_group("has_save_data"):
		#if saveable.is_in_group("persisting_node"):
			#continue
			
		var internal_name = saveable.internal_name
		var loaded_data = FindSaveDataEntryWithName(save_data, internal_name)
		
		# No data found for saveable node
		if len(loaded_data) == 0 and internal_name not in applied_customly:
			print("Issue applying loaded data to node " + str(saveable) + ", no data for it in save file.")
			continue
			
		# Applies loaded data to the saveable node if there is a save data entry for it
		if len(loaded_data) > 0:
			save_data_component = gdExtensions.GetImmediateChildOfType("SaveDataComponent", saveable)
			save_data_component.call("ApplyLoadedData", loaded_data)
			
			# Removes loaded data of the affected node from save data
			var loaded_key = save_data.find_key(loaded_data)
			save_data.erase(loaded_key)
	
	# Any left over sections of save data are flagged. Reduces errors and can find data not being saved
	# or used properly
	for entry_key in save_data:
		print("Issue loading data: " + str(save_data[entry_key]) + ", it is not applicable to any nodes.")


# Function Information
# Use - Saving/Loading Game Data
# Does - Formats save data in a more human readable format
func FormatJSON(value, indent := 0) -> String:
	var ind = "  ".repeat(indent)

	if value is Dictionary:
		var parts := []
		for key in value:
			var v = value[key]

			if v is Array or v is Dictionary:
				parts.append("\n" + ind + "  \"" + str(key) + "\": " + FormatJSON(v, indent + 1))
			else:
				parts.append("\n" + ind + "  \"" + str(key) + "\": " + FormatJSON(v, 0))

		return "{" + ",".join(parts) + "\n" + ind + "}"

	elif value is Array:
		# Detect 2D array
		if value.size() > 0 and value[0] is Array:
			var rows := []
			for row in value:
				rows.append("\n" + ind + "  " + FormatJSON(row, 0))
			return "[" + ",".join(rows) + "\n" + ind + "]"
		else:
			# Normal 1D arrays stay inline
			var parts := []
			for v in value:
				parts.append(FormatJSON(v, 0))
			return "[" + ", ".join(parts) + "]"

	else:
		return JSON.stringify(value)


# Function Information
# Use - Saving/Loading Game Data
# Does - Returns the saved data associated to the given name
func FindSaveDataEntryWithName(data: Dictionary, given_name: String) -> Dictionary:
	for entry in data.values():
		if entry.has("internal_name"):
			if entry["internal_name"] == given_name:
				return entry
	return { }


# Function Information
# Use - Saving/Loading Game Data
# Does - Returns whether the given data has all expected fields, or whether methods for using all fields
#		are in place
# Debug - Error Statements
#		Either missing fields, or fields not used properly
func CheckLoadedDataIsValid(expected_fields: Array, given_fields: Array, node: Node) -> bool:
	var missing_fields: Array
	var leftover_fields: Array
	
	# Iterate over each array of fields and records whether any not used or not given
	for data in expected_fields:
		if data not in given_fields:
			missing_fields.append(data)
	for data in given_fields:
		if data not in expected_fields and data != "internal_name" and data != "persisting_node":
			leftover_fields.append(data)
			
	# Print error and return false if any fields missing or not used
	if len(leftover_fields) > 0 or len(missing_fields) > 0:
		print("Issue applying loaded data to " + str(node) + ", the following data in the dictionary not applied: " + str(leftover_fields) + " and following entries expected but not present: " + str(missing_fields))
		return false
	return true


# Function Information
# Use - Saving/Loading Game Data
# Does - Apply loaded data to all global scripts/nodes that have save data
func ApplyLoadedGlobalData() -> void:
	var entries_to_remove: Array[String]
	
	# Checks whether each global node/script has required saving method or marked as non
	# saveable. Future proofing to prevent issues when making new globals
	for global in globals:
		if !global.has_method("ApplyLoadedData") and global.get("not_saveable") == null:
			print("Error applying loaded data to " + str(global) + ", it is missing ApplyLoadedData method or is not marked as not-saveable.")
	
	# For every entry in save data that is for a global script/node, apply the loaded data
	for entry_key in save_data:
		if entry_key in globals_as_strings:
			var index = globals_as_strings.find(entry_key)
			var global = globals[index]
			global.call("ApplyLoadedData", save_data[entry_key])
			entries_to_remove.append(entry_key)
	for entry in entries_to_remove:
		save_data.erase(entry)


# Function Information
# Use - Saving/Loading Game Data
# Does - Create crop objects and apply loaded data for each crop
func AssembleCropFields() -> void:
	var entries_to_remove: Array[String]
	
	for entry_key in save_data:
		var loaded_data = save_data[entry_key]
		var object_internal_name = loaded_data["internal_name"]
		
		# If entry is for a crop
		if Database.database.has(object_internal_name) and Database.database[object_internal_name] is CropData:
			# Setups more readable and usable variables for the data 
			var object_data = Database.database[object_internal_name] as CropData
			var tilemap_cell_position = Vector2i(loaded_data["tilemap_cell_position_x"], loaded_data["tilemap_cell_position_y"])
			
			# Should be in world data, if not, error in applying global data
			if tilemap_cell_position not in WorldComponentData.planted_crops:
				print("Crop with data " + str(loaded_data) + " does not have position saved in world data. Likely error applying global data.")
				continue
			
			# Gets and instantiates crop scene based on loaded data
			var crop_scene: PackedScene = Database.GetCropScene(object_data.seed_enum)
			var crop_instance = crop_scene.instantiate() as Crop
			
			# Places crop in proper references and node structure
			crop_fields.add_child(crop_instance)
			WorldComponentData.planted_crops[tilemap_cell_position] = crop_instance
			
			# Applies global data and marks not to use loaded data again
			crop_instance.ApplyLoadedData(loaded_data)
			entries_to_remove.append(entry_key)
			
	for entry in entries_to_remove:
		save_data.erase(entry)


# Function Information
# Use - Saving/Loading Game Data
# Does - Create building objects, their associated interfaces and applies loaded data for each building
func SetupBuildings() -> void:
	var entries_to_remove: Array[String]
	
	for entry_key in save_data.keys():
		var loaded_data = save_data[entry_key]
		var object_internal_name = loaded_data["internal_name"]
		
		# Do not create new buildings for buildings that persist through saves, apply loaded data later
		if loaded_data.has("persisting_node"):
			continue
			
		if Database.database.has(object_internal_name) and Database.database[object_internal_name] is BuildingData:
			# Setups more readable and usable variables for the data 
			var building_data = Database.database[object_internal_name] as BuildingData
			var tilemap_cell_position = Vector2i(loaded_data["tilemap_cell_position_x"], loaded_data["tilemap_cell_position_y"])
			
			# Instantiates the required building scene
			var building_instance = building_data.building_scene.instantiate() as Building
			
			# Places building in proper references and node structure
			buildings.add_child(building_instance)
			WorldComponentData.built_tiles[tilemap_cell_position] = building_instance
			
			# Builds correct interface scene for loaded building
			var interface_data = Database.database[building_data.interface_name] as InterfaceData
			var interface = interface_data.interface_scene.instantiate() as BuildingInterface
			
			# Places interface in proper node structure, connects needed references and hides the interface
			interface_ui.add_child(interface)
			building_instance.interface = interface
			interface.associated_building = building_instance
			interface.hide()
			
			# Applies global data and marks not to use loaded data again
			building_instance.ApplyLoadedData(loaded_data)
			entries_to_remove.append(entry_key)
			
	for entry in entries_to_remove:
		save_data.erase(entry)


# Function Information
# Use - Saving/Loading Game Data
# Does - Applies loaded data for each interface that sustains between game instances to the 
#		corresponding interface
func LoadUserInterfaces() -> void:
	var entries_to_remove: Array[String]
	
	for entry_key in save_data:
		var loaded_data = save_data[entry_key]
		var interface_internal_name = loaded_data["internal_name"]
		
		# Applies loaded data to appropiate interface
		if interface_internal_name == inventory_interface.internal_name:
			inventory_interface.ApplyLoadedData(loaded_data)
		elif interface_internal_name == hotbar_interface.internal_name:
			hotbar_interface.ApplyLoadedData(loaded_data)
		else:
			# If not one of the interfaces, avoid adding to entries to remove
			continue
		
		# Marks data to not be used again
		entries_to_remove.append(entry_key)
	
	for entry in entries_to_remove:
		save_data.erase(entry)
