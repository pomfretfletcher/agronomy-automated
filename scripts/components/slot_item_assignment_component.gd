class_name SlotItemAssignmentComponent
extends Control

@onready var storage_interface: StorageInterface = $".."
var current_slots: Array[Array]

func _unhandled_input(event: InputEvent) -> void:
	if storage_interface.is_opened:
		pass
