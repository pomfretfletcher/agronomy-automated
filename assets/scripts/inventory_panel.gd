extends PanelContainer

@onready var tool_slot: Button = $MarginContainer/HBoxContainer/ToolSlot
@onready var seed_slot: Button = $MarginContainer/HBoxContainer/SeedSlot
var slots: Array[Slot]

var current_slot: int = 0

func _ready() -> void:
	# Setup initial focus on slot 1, item 1
	slots = [tool_slot, seed_slot]
	FocusSlots()
	
func _unhandled_input(event: InputEvent) -> void:
	# If attempting to access a slot with a numbered input
	if event is InputEventKey && event.keycode >= KEY_1 && event.keycode <= KEY_9 && event.is_action_pressed("access_hotbar_slot"):
		var lowest_val = KEY_1
		var greatest_val = lowest_val + len(slots)
		
		# If input outside current number of slots
		if event.keycode > greatest_val or event.keycode < lowest_val:
			return
		
		# Change slot to inputted slot
		current_slot = event.keycode - lowest_val
		FocusSlots()
	
	elif event.is_action_pressed("previous_hotbar_slot"):
		current_slot = abs((current_slot - 1) % len(slots))
		FocusSlots()
		
	elif event.is_action_pressed("next_hotbar_slot"):
		current_slot = (current_slot + 1) % len(slots)
		FocusSlots()
		
	elif event.is_action_pressed("next_item_in_slot"):
		for slot in slots:
			if slot.has_focus():
				slot.ChangeToNextItem()
		
	elif event.is_action_pressed("previous_item_in_slot"):
		for slot in slots:
			if slot.has_focus():
				slot.ChangeToPreviousItem()
			
func FocusSlots() -> void:
	var new_slot = slots[current_slot]
	new_slot.grab_focus()
