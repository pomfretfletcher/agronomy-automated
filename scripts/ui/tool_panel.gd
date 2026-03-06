extends PanelContainer

@onready var tool_slot: Panel = $MarginContainer/HBoxContainer/ToolSlot
@onready var seed_slot: Panel = $MarginContainer/HBoxContainer/SeedSlot
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
		if event.keycode >= greatest_val or event.keycode < lowest_val:
			return
		
		# Change slot to inputted slot
		slots[current_slot].UnequipFromSlot()
		current_slot = event.keycode - lowest_val
		FocusSlots()
	
	elif event.is_action_pressed("previous_hotbar_slot"):
		slots[current_slot].UnequipSlot()
		current_slot = abs((current_slot - 1) % len(slots))
		slots[current_slot].EquipSlot()
		FocusSlots()
		
	elif event.is_action_pressed("next_hotbar_slot"):
		slots[current_slot].UnequipSlot()
		current_slot = (current_slot + 1) % len(slots)
		slots[current_slot].EquipSlot()
		FocusSlots()
		
	elif event.is_action_pressed("next_item_in_slot"):
		slots[current_slot].ChangeToNextItem()

	elif event.is_action_pressed("previous_item_in_slot"):
		slots[current_slot].ChangeToPreviousItem()
			
func FocusSlots() -> void:
	for i in range(slots.size()):
		if i == current_slot:
			slots[i].add_theme_stylebox_override("panel", slots[i].theme.get_stylebox("selected", "ToolPanel"))
		else:
			slots[i].add_theme_stylebox_override("panel", slots[i].theme.get_stylebox("normal", "ToolPanel"))
