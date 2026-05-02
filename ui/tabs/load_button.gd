extends Panel

@export var save_load_tab: SaveLoadTab


func _gui_input(event: InputEvent) -> void:
	if event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		save_load_tab.LoadButtonPressed()
