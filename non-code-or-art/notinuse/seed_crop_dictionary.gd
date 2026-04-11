extends Node

var not_saveable: bool = true

@export var crop_scene_dictionary: Dictionary[DataTypes.Seeds, PackedScene]

@export var backup_dict: Dictionary[DataTypes.Seeds, PackedScene]

# Information
# Use - Internal
# By - Game Startup
# For - Flags error if something has happened to dictionary
# Explanation -
#	Flags error if something has happened to dictionary - Make sure reduce
#	chance of error later
# Debug - N/A
func _ready() -> void:
	# Used to prevent errors in packedscenes getting unlinked when folder
	# system is changed
	if len(crop_scene_dictionary.keys()) == 0:
		print("Issue in Crop Scene Dictionary.")
		print(crop_scene_dictionary.keys())
		return
