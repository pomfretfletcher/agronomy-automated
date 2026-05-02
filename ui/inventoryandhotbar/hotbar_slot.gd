class_name HotbarSlot
extends InterfaceSlot


# Function Information
# Use - Interface Use
# Does - Highlights the slot when the player's mouse hovers over
func _on_mouse_entered() -> void:
	pass


# Function Information
# Use - Interface Use
# Does - Unhighlights the slot once the player's mouse stops hovering over
func _on_mouse_exited() -> void:
	pass


# Allow rarrengment and moving of items to and from hotbar slots, but make sure to equip the
# right item each time anything anything may have changed
func _gui_input(event: InputEvent) -> void:
	super(event)
	if event.is_pressed():
		interface_handler.FocusHotbarSlots()


func SetSelectedStyle() -> void:
	add_theme_stylebox_override("panel", get_theme_stylebox("selected", "HotbarSlot"))
