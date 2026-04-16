class_name HotbarSlot
extends InventorySlot


func _gui_input(event: InputEvent) -> void:
	# Single item attempting to be sent between interfacces
	if event is InputEventMouseButton and event.is_released() and event.button_index == MOUSE_BUTTON_LEFT:
		if not is_empty and interface.being_used_in_interface_interaction:
			var data: Dictionary
			data["from"] = self
			interface.single_item_movement.emit(data)


# Function Information - Overriden Function to ignore parent class function
func _on_mouse_entered() -> void:
	pass


# Function Information - Overriden Function to ignore parent class function
func _on_mouse_exited() -> void:
	pass


# Function Information - Overriden Function to ignore parent class function
func _on_focus_exited() -> void:
	pass
