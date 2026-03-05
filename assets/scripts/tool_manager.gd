extends Node

var selected_tool: DataTypes.Tools = DataTypes.Tools.None
var selected_seed: DataTypes.Seeds = DataTypes.Seeds.None

signal tool_selected(tool: DataTypes.Tools)
signal seed_selected(seed: DataTypes.Seeds)

func SelectTool(tool: DataTypes.Tools) -> void:
	tool_selected.emit(tool)
	selected_tool = tool

func SelectSeed(seed: DataTypes.Seeds) -> void:
	seed_selected.emit(seed)
	selected_seed = seed
