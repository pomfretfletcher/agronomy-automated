class_name SaveDataComponent
extends Node

var parent_node: Node
var save_data: Dictionary

func _ready() -> void:
	parent_node = get_parent()
	parent_node.add_to_group("has_save_data")

func GetSaveData():
	if parent_node.has_method("GetSaveData"):
		save_data = parent_node.call("GetSaveData")
		return save_data
	else:
		print("Error saving data of node " + str(parent_node) + ", it is missing GetSaveData method.")
		return null

func ApplyLoadedData(loaded_save_data) -> void:
	if loaded_save_data == null:
		print("Error applying loaded save data to node " + str(parent_node) + ", save data is null.")
		return
	if !loaded_save_data is Dictionary:
		print("Error appying loaded save data to node " + str(parent_node) + ", save data is not a dictionary.")
		return
		
	if parent_node.has_method("ApplyLoadedData"):
		parent_node.call("ApplyLoadedData", loaded_save_data)
	else:
		print("Error applying loaded save data to node " + str(parent_node) + ", it is missing ApplyLoadedData method.")

# GetSaveData template
#func GetSaveData() -> Dictionary:
	#var save_data = {
		#
	#}
	#return save_data

# ApplyLoadedData template
#func ApplyLoadedData(loaded_save_data: Dictionary) -> void:
	#var applied = []	
	#SaveLoadManager.CheckLoadedDataIsValid(applied, loaded_save_data.keys(), self)
	
	#if loaded_save_data.has("xxx"): xxx = loaded_save_data["xxx"]
	
