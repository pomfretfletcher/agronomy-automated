extends Node

var selected_tool: DataTypes.Tools = DataTypes.Tools.None
var selected_seed: DataTypes.Seeds = DataTypes.Seeds.None
var selected_seed_crop_scene

func SelectTool(tool: DataTypes.Tools) -> void:
	selected_tool = tool
	
func SelectSeed(new_seed: DataTypes.Seeds, crop_scene: PackedScene) -> void:
	selected_seed = new_seed
	selected_seed_crop_scene = crop_scene
