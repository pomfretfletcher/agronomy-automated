class_name HotbarInterface
extends Interface


func _unhandled_input(event: InputEvent) -> void:
	# If attempting to access a slot with a numbered input
	if event is InputEventKey and ((event.keycode >= KEY_1 and event.keycode <= KEY_9) or event.keycode == KEY_0) and event.is_action_pressed("access_hotbar_slot"):
		interface_handler.ChangeToHotbarSlot(event)
	
	elif event.is_action_pressed("previous_hotbar_slot"):
		interface_handler.MoveToPreviousHotbarSlot()
		
	elif event.is_action_pressed("next_hotbar_slot"):
		interface_handler.MoveToNextHotbarSlot()
