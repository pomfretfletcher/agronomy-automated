extends Node

@export var texture_dictionary: Dictionary[String, Texture2D]

@export var backup_dict: Dictionary[String, Texture2D]

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
	if len(texture_dictionary.keys()) == 0:
		print("Issue in name texture Dictionary.")
		print(texture_dictionary.keys())
		return
