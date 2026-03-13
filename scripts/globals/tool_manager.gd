extends Node

var selected_tool: DataTypes.Tools = DataTypes.Tools.None
var selected_seed: DataTypes.Seeds = DataTypes.Seeds.None
var selected_seed_crop_scene

signal tool_selected(tool: DataTypes.Tools)
signal seed_selected(seed: DataTypes.Seeds)

func SelectTool(tool: DataTypes.Tools) -> void:
	tool_selected.emit(tool)
	selected_tool = tool
	
func SelectSeed(seed: DataTypes.Seeds, crop_scene: PackedScene) -> void:
	seed_selected.emit(seed)
	selected_seed = seed
	selected_seed_crop_scene = crop_scene
