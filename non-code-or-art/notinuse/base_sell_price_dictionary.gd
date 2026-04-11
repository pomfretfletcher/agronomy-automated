extends Node

var not_saveable: bool = true

@export var price_dictionary: Dictionary[String, int]
@export var backup_dictionary: Dictionary[String, int]

# Information
# Use - Internal
# By - Game Startup
# For - Flags error if something has happened to dictionary
# Explanation -
#	Flags error if something has happened to dictionary - Make sure reduce
#	chance of error later
# Debug - N/A
func _ready() -> void:
	# Used to prevent errors in data getting lost when folder
	# system is changed
	if len(price_dictionary.keys()) == 0:
		print("Issue in base price Dictionary.")
		print(price_dictionary.keys())
		return
