class_name CropDisplayInterface
extends PanelContainer

@export var name_label: Label
@export var percent_label: Label

# Information
# Use - Internal
# By - Game Startup
# For - Shows module
# Explanation -
#	Shows module (allows to be hidden during editor)
# Debug - N/A
func _ready() -> void:
	visible = true
