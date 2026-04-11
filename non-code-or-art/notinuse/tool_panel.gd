extends PanelContainer

@export var equipment_slot: EquipmentSlot
@export var seed_slot: EquipmentSlot
@export var slot_container: HBoxContainer

var inventory_slot_framework: PackedScene = ReusedPackedSceneDictionary.packed_scene_dictionary["inventory_slot_framework"]

var equipment_slots: Array[EquipmentSlot]
#var inventory_slots: Dictionary[String, InventorySlot]
var slots: Array

var current_slot: int = 0

func _ready() -> void:
	# Setup initial focus on slot 1, item 1
	equipment_slots = [equipment_slot, seed_slot]
	slots = [equipment_slot, seed_slot]
	FocusSlots()

# Interaction - TODO
func _unhandled_input(event: InputEvent) -> void:
	# If attempting to access a slot with a numbered input
	if event is InputEventKey and event.keycode >= KEY_1 and event.keycode <= KEY_9 and event.is_action_pressed("access_hotbar_slot"):
		var lowest_val = KEY_1
		var greatest_val = lowest_val + len(slots)
		
		# If input outside current number of slots
		if event.keycode >= greatest_val or event.keycode < lowest_val:
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
		if slots[current_slot] is EquipmentSlot:
			slots[current_slot].ChangeToNextItem()

	elif event.is_action_pressed("previous_item_in_slot"):
		if slots[current_slot] is EquipmentSlot:
			slots[current_slot].ChangeToPreviousItem()
			
func FocusSlots() -> void:
	# Change theme of slot depending on whether it is the currently selected slot
	for i in range(slots.size()):
		if i == current_slot:
			SetSelectedStyle(slots[i])
			slots[i].EquipSlot()
		else:
			SetNormalStyle(slots[i])
			slots[i].UnequipSlot()

func SetNormalStyle(obj: Node) -> void:
	obj.add_theme_stylebox_override("panel", obj.get_theme_stylebox("normal", "HotbarSlot"))

func SetSelectedStyle(obj: Node) -> void:
	obj.add_theme_stylebox_override("panel", obj.get_theme_stylebox("selected", "HotbarSlot"))
