extends Node

@export var packed_scene_dictionary: Dictionary[String, PackedScene]
@export var backup_dict: Dictionary[String, PackedScene]

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
	if len(packed_scene_dictionary.keys()) == 0:
		print("Issue in reused packed scene Dictionary.")
		print(packed_scene_dictionary.keys())
		return
