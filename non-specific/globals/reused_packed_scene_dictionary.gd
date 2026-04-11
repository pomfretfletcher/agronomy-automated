extends Node

var not_saveable: bool = true

@export var packed_scene_dictionary: Dictionary[String, PackedScene]
@export var backup_dict: Dictionary[String, PackedScene]

var item_framework: PackedScene

# Function Information
# Use - Error Checking
# Does - Stops game if error occured in dictionary [If empty], then gets some of the most used frameworks into
#		more accessible variables
# Debug - N/A
func _ready() -> void:
	# Used to prevent errors in packedscenes getting unlinked when folder
	# system is changed
	if len(packed_scene_dictionary.keys()) == 0:
		print("Issue in reused packed scene Dictionary.")
		print(packed_scene_dictionary.keys())
		return
	AssembleDefaultFrameworks()

func AssembleDefaultFrameworks() -> void:
	item_framework = packed_scene_dictionary.get("item_framework")
