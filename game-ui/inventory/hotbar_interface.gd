class_name HotbarInterface
extends UserInterface

var hotbar_slots: Array[HotbarSlot]
var current_slot: HotbarSlot
var current_slot_index: int = 0
var current_item: String
@export var initial_items: Array[String]

# Function Information
# Use - Interface Use, Hotbar
# Does - Gets needed frameworks for constructing interface, then calls for interface to be setup
# Debug - N/A
func _ready() -> void:
	slot_framework = ReusedPackedSceneDictionary.packed_scene_dictionary["hotbar_slot_framework"]
	row_framework = ReusedPackedSceneDictionary.packed_scene_dictionary["hotbar_row_framework"]
	show()
	call_deferred("SetupInterface")

func SetupInterface() -> void:
	for y in range(horizontal_slot_count):
		var new_slot: InterfaceSlot = slot_framework.instantiate() as InterfaceSlot
		new_slot.interface = self
		hotbar_slots.append(new_slot)
	
	var row_node: PanelContainer = row_framework.instantiate()
	var row_margin_container = row_node.get_child(0).get_child(0)
	for slot in hotbar_slots:
		row_margin_container.add_child(slot)
	row_container.add_child(row_node)
	
	var slotcomp = slot_item_assignment_component as InventorySlotItemAssignmentComponent
	slotcomp.hotbar_slots = hotbar_slots
	AddInitialItems()
	
	current_slot = hotbar_slots[current_slot_index]
	FocusSlots()

func AddInitialItems() -> void:
	var index = 0
	for item in initial_items:
		InventoryManager.AddItemToInventoryWithoutSignal(item, 1)
		slot_item_assignment_component.current_contents.set(item, 1)
		
		var slot = hotbar_slots[index]
		slot.SetItem(item)
		
		index += 1
	
	current_slot_index = 0
	current_slot = hotbar_slots[current_slot_index]
	current_item = current_slot.item_name

func _unhandled_input(event: InputEvent) -> void:
	# If attempting to access a slot with a numbered input
	if event is InputEventKey and ((event.keycode >= KEY_1 and event.keycode <= KEY_9) or event.keycode == KEY_0) and event.is_action_pressed("access_hotbar_slot"):
		var lowest_val = KEY_1
		var greatest_val = lowest_val + len(hotbar_slots)

		# If input outside current number of slots
		if (event.keycode >= greatest_val or event.keycode < lowest_val) and event.keycode != KEY_0:
			return
		
		# Change slot to inputted slot
		if event.keycode != KEY_0:
			current_slot_index = event.keycode - lowest_val
		if event.keycode == KEY_0 and len(hotbar_slots) >= 10:
			current_slot_index = 9
			
		current_slot = hotbar_slots[current_slot_index]
		FocusSlots()
	
	elif event.is_action_pressed("previous_hotbar_slot"):
		if current_slot_index != 0:
			current_slot_index = current_slot_index - 1
		else:
			current_slot_index = len(hotbar_slots) - 1
		current_slot = hotbar_slots[current_slot_index]
		FocusSlots()
		
	elif event.is_action_pressed("next_hotbar_slot"):
		if current_slot_index != len(hotbar_slots) - 1:
			current_slot_index = current_slot_index + 1
		else:
			current_slot_index = 0
		current_slot = hotbar_slots[current_slot_index]
		FocusSlots()

func FocusSlots():
	for slot in hotbar_slots:
		if slot == current_slot:
			SetSelectedStyle(current_slot)
			if !current_slot.is_empty:
				EquipItem(current_slot.item_name)
			else:
				UnequipItem()
		else:
			SetNormalStyle(slot)

func SetNormalStyle(slot: HotbarSlot) -> void:
	slot.add_theme_stylebox_override("panel", slot.get_theme_stylebox("normal", "HotbarSlot"))

func SetSelectedStyle(slot: HotbarSlot) -> void:
	slot.add_theme_stylebox_override("panel", slot.get_theme_stylebox("selected", "HotbarSlot"))

func EquipItem(item: String) -> void:
	if item != "":
		ToolManager.EquipTool(item)

func UnequipItem() -> void:
	if current_item == "":
		ToolManager.UnequipAllTools()

# Function Information
# Use - Interface Saving, Hotbar
# Does - Returns an array with the item names positioned within the interface's slots
# Debug - N/A
func GetSlotReferences() -> Array:
	var reference_array: Array
	# Constructs reference array that will be returned full of empty values
	for x in range(horizontal_slot_count):
		reference_array.append("")
	
	# Sets each value of the reference array equal to the item name of its corresponding slot in the interface slots
	for col_index in range(len(hotbar_slots)):
		var cur_slot = hotbar_slots[col_index] as InterfaceSlot
		if !cur_slot.is_empty:
			reference_array[col_index] = cur_slot.item_name
	return reference_array

func GetSaveData() -> Dictionary:
	var save_data = {
		"hotbar_slots": GetSlotReferences(),
		"internal_name": internal_name,
		"current_slot_index": current_slot_index,
		"current_item": current_item
	}
	return save_data

func ApplyLoadedData(loaded_save_data: Dictionary) -> void:
	var applied = ["hotbar_slots", "current_slot_index", "current_item"]	
	SaveLoadManager.CheckLoadedDataIsValid(applied, loaded_save_data.keys(), self)
	
	if loaded_save_data.has("hotbar_slots"):
		call_deferred("SetupLoadedSlots", loaded_save_data)
	if loaded_save_data.has("current_slot_index"): 
		current_slot_index = loaded_save_data["current_slot_index"]
		current_slot = hotbar_slots[current_slot_index]
		FocusSlots()
	if loaded_save_data.has("current_item"): current_item = loaded_save_data["current_item"]
	
func SetupLoadedSlots(loaded_save_data: Dictionary) -> void:
	var reference_array = loaded_save_data["hotbar_slots"]
	if gdExtensions.IsArray1D(reference_array):
			for col_index in range(len(reference_array)):
				if reference_array[col_index] != "":
					var slot = hotbar_slots[col_index] as InterfaceSlot
					slot.SetItem(reference_array[col_index])
