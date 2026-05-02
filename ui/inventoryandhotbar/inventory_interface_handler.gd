class_name InventoryInterfaceHandler
extends InterfaceHandler


var hotbar_interface: HotbarInterface
var hotbar_slots: Array[InterfaceSlot]

var current_hotbar_slot: HotbarSlot
var current_hotbar_slot_index: int = 0
var current_hotbar_item: String

# Setup Data
@export var hotbar_slot_count: int
@export var hotbar_interface_internal_name: String
@export var starting_hotbar: Dictionary[String, int]
@export var starting_hotbar_order: Array[String]


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("open_and_close_inventory"):
		if not interface_is_open:
			OpenInterface()
			player.RemoveControl()
		elif interface_is_open:
			CloseInterface()
			player.ReturnControl()
	
	if interface_is_open:
		if event.is_action_pressed("next_interface_tab"):
			MoveToNextInterfacePage()
		elif event.is_action_pressed("previous_interface_tab"):
			MoveToPreviousInterfacePage()


func SetupInterfaceDisplay() -> void:
	super()
	
	# Get all needed data and packed scenes for constructing the interface
	var interface_data = Database.database[hotbar_interface_internal_name] as InterfaceData
	var interface_packed_scene = interface_data.interface_scene
	var row_packed_scene = interface_data.row_scene
	var slot_packed_scene = interface_data.slot_scene
	
	# Create instance of the interface this component will be handling
	var interface_instance: Interface = interface_packed_scene.instantiate()
	# Connect the interface and this component together
	hotbar_interface = interface_instance
	interface_instance.interface_handler = self
	# Add interface to the scene node for interface ui components
	WorldComponentData.interface_ui.add_child(interface_instance)
	
	# Create instance of row
	var row_instance: InterfaceRow = row_packed_scene.instantiate()
	# Attach row instance to interface
	interface_instance.add_child(row_instance)
	
	for slot_to_make in hotbar_slot_count:
		# Crate instance of slot
		var slot_instance: InterfaceSlot = slot_packed_scene.instantiate()
		# Add slot to row array in slot structure for access to it
		hotbar_slots.append(slot_instance)
		# Add page instance to the slots within the currently being made row
		row_instance.slot_container.add_child(slot_instance)
		# Connect slot instance to this node
		slot_instance.interface_handler = self


func SetupInitialData() -> void:
	super()
	FocusHotbarSlots()
	SetupInitialHotbar()


func IsItemInInterface(item_name: String, on_current_page: bool = false) -> bool:
	if not on_current_page:
		for slot in hotbar_slots:
			slot = slot as InterfaceSlot
			if slot.item_name == item_name:
				return true
		for page in interface_slots:
			for row in page:
				for slot in row:
					slot = slot as InterfaceSlot
					if slot.item_name == item_name:
						return true
	elif on_current_page:
		var page_index = interface_pages.find(current_page)
		for row in interface_slots[page_index]:
			for slot in row:
				slot = slot as InterfaceSlot
				if slot.item_name == item_name:
					return true
	return false


func FindFirstSlotWithItem(item_name: String, on_current_page: bool = false) -> InterfaceSlot:
	if not on_current_page:
		for slot in hotbar_slots:
			slot = slot as InterfaceSlot
			if slot.item_name == item_name:
				return slot
		for page in interface_slots:
			for row in page:
				for slot in row:
					slot = slot as InterfaceSlot
					if slot.item_name == item_name:
						return slot
	elif on_current_page:
		var page_index = interface_pages.find(current_page)
		for row in interface_slots[page_index]:
			for slot in row:
				slot = slot as InterfaceSlot
				if slot.item_name == item_name:
					return slot
	return null


func FindFirstEmptySlot(on_current_page: bool = false) -> InterfaceSlot:
	if not on_current_page:
		for slot in hotbar_slots:
			slot = slot as InterfaceSlot
			if slot.is_empty:
				return slot
		for page in interface_slots:
			for row in page:
				for slot in row:
					slot = slot as InterfaceSlot
					if slot.is_empty:
						return slot
	elif on_current_page:
		var page_index = interface_pages.find(current_page)
		for row in interface_slots[page_index]:
			for slot in row:
				slot = slot as InterfaceSlot
				if slot.is_empty:
					return slot
	return null


func FindFirstEmptyHotbarSlot() -> InterfaceSlot:
	for slot in hotbar_slots:
		slot = slot as InterfaceSlot
		if slot.is_empty:
			return slot
	return null


func IsThereSpaceInInterface(on_current_page: bool = false) -> bool:
	if not on_current_page:
		for slot in hotbar_slots:
			slot = slot as InterfaceSlot
			if slot.is_empty:
				return true
		for page in interface_slots:
			for row in page:
				for slot in row:
					slot = slot as InterfaceSlot
					if slot.is_empty:
						return true
	elif on_current_page:
		var page_index = interface_pages.find(current_page)
		for row in interface_slots[page_index]:
			for slot in row:
				slot = slot as InterfaceSlot
				if slot.is_empty:
					return true
	return false


func ChangeToHotbarSlot(event: InputEvent) -> void:
	var lowest_val = KEY_1
	var greatest_val = lowest_val + len(hotbar_slots)

	# If input outside current number of slots
	if (event.keycode >= greatest_val or event.keycode < lowest_val) and event.keycode != KEY_0:
		return
	
	# Change slot to inputted slot
	if event.keycode != KEY_0:
		current_hotbar_slot_index = event.keycode - lowest_val
	if event.keycode == KEY_0 and len(hotbar_slots) >= 10:
		current_hotbar_slot_index = 9
		
	FocusHotbarSlots()


func MoveToNextHotbarSlot() -> void:
	if current_hotbar_slot_index != len(hotbar_slots) - 1:
		current_hotbar_slot_index = current_hotbar_slot_index + 1
	else:
		current_hotbar_slot_index = 0
	FocusHotbarSlots()


func MoveToPreviousHotbarSlot() -> void:
	if current_hotbar_slot_index != 0:
		current_hotbar_slot_index = current_hotbar_slot_index - 1
	else:
		current_hotbar_slot_index = len(hotbar_slots) - 1
	FocusHotbarSlots()


func FocusHotbarSlots():
	current_hotbar_slot = hotbar_slots[current_hotbar_slot_index]
	UnequipHotbarItem()
	for slot in hotbar_slots:
		if slot == current_hotbar_slot:
			slot.SetSelectedStyle()
			if !current_hotbar_slot.is_empty:
				EquipHotbarItem(current_hotbar_slot.item_name)
		else:
			slot.SetNormalStyle()


func EquipHotbarItem(item: String) -> void:
	if item != "":
		ToolManager.EquipTool(item)
		current_hotbar_item = item


func UnequipHotbarItem() -> void:
	ToolManager.UnequipAllTools()
	current_hotbar_item = ""


func SetupInitialHotbar() -> void:
	for item in starting_hotbar_order:
		if item not in starting_hotbar:
			print("Error setting up item " + item + " in initial hotbar. No amount set.")
			continue
		else:
			var slot: InterfaceSlot = FindFirstEmptyHotbarSlot()
			var amount = starting_hotbar[item]
			slot.SetItem(item)
			slot.SetAmount(amount)
			InventoryManager.AddItemToInventoryWithoutSignal(item, amount)
	
	if not hotbar_slots[0].is_empty:
		EquipHotbarItem(hotbar_slots[0].item_name)


func GetSaveData() -> Dictionary:
	var save_data = super()
	save_data["hotbar_items"] = GetHotbarItems()
	save_data["hotbar_amounts"] = GetHotbarAmounts()
	save_data["current_hotbar_slot_index"] = current_hotbar_slot_index
	save_data["current_hotbar_item"] = current_hotbar_item
	
	return save_data


func ApplyLoadedData(loaded_save_data: Dictionary) -> void:
	var applied = ["slot_items", "slot_amounts", "hotbar_items", "hotbar_amounts", "current_hotbar_slot_index", "current_hotbar_item"]	
	SaveLoadManager.CheckLoadedDataIsValid(applied, loaded_save_data.keys(), self)
	
	if loaded_save_data.has("slot_items") and loaded_save_data.has("slot_amounts"):
		RecreateLoadedInterface(loaded_save_data["slot_items"], loaded_save_data["slot_amounts"])
	if loaded_save_data.has("hotbar_items") and loaded_save_data.has("hotbar_amounts"):
		RecreateLoadedHotbar(loaded_save_data["hotbar_items"], loaded_save_data["hotbar_amounts"])
	if loaded_save_data.has("current_hotbar_slot_index"): 
		current_hotbar_slot_index = loaded_save_data["current_hotbar_slot_index"]
		FocusHotbarSlots()
	if loaded_save_data.has("current_hotbar_item"): current_hotbar_item = loaded_save_data["current_hotbar_item"]


func GetHotbarItems() -> Array[String]:
	var reference_array: Array[String] = []
	for slot in hotbar_slots:
		if slot.is_empty:
			reference_array.append("")
		else:
			reference_array.append(slot.item_name)
	return reference_array


func GetHotbarAmounts() -> Array[int]:
	var reference_array: Array[int] = []
	for slot in hotbar_slots:
		if slot.is_empty:
			reference_array.append(0)
		else:
			reference_array.append(slot.amount)
	return reference_array


func RecreateLoadedHotbar(item_reference_array: Array, amount_reference_array: Array) -> void:
	for slot_index in range(len(item_reference_array)):
		# Access information in a more easy to use format
		var slot_item = item_reference_array[slot_index]
		var slot_amount = amount_reference_array[slot_index]
		var interface_slot: InterfaceSlot = hotbar_slots[slot_index]
		
		# Clear currently stored item in slot ready for loaded data
		interface_slot.RemoveItem()
		
		# Can only set item if have both an amount and item reference
		if slot_item == "" and slot_amount != 0:
			print("Error when loading interface of hotbar, a slot has a set amount but not an item.")
			continue
		if slot_item != "" and slot_amount == 0:
			print("Error when loading interface of hotbar, a slot has a set item but not an amount.")
			continue
		
		# Set item and amount of slot if given both
		if slot_item != "":
			interface_slot.SetItem(slot_item)
			interface_slot.SetAmount(slot_amount)
