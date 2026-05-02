class_name InterfaceHandler
extends Node


@onready var player: Player = get_tree().get_first_node_in_group("player")
var connected_interface: Interface

# A 3D array consisting of each page of the interface's slots. Fe a building with two pages of
# 3x5 slot structure would be be a 2x3x5 Array[Array[Array[Slot]]]
var interface_slots: Array[Array]

var interface_pages: Array[InterfacePage]

# Setup data
@export var page_count: int
@export var row_count: int
@export var col_count: int
@export var interface_internal_name: String
@export var internal_name: String

# Run time values for logic
var amount_of_pages: int = 0
var current_page_index: int
var current_page: InterfacePage

# Status bools of interface
var interface_is_open: bool
var in_interaction: bool = false
var has_item_in_cursor: bool = false


func _ready() -> void:
	SetupInterfaceDisplay()
	SetupInitialData()


func _unhandled_input(event: InputEvent) -> void:
	if interface_is_open:
		if event.is_action_pressed("next_interface_tab"):
			MoveToNextInterfacePage()
		elif event.is_action_pressed("previous_interface_tab"):
			MoveToPreviousInterfacePage()


func SetupInterfaceDisplay() -> void:
	# Get all needed data and packed scenes for constructing the interface
	var interface_data = Database.database[interface_internal_name] as InterfaceData
	var interface_packed_scene = interface_data.interface_scene
	var page_packed_scene = interface_data.page_scene
	var slot_packed_scene = interface_data.slot_scene
	var row_packed_scene = interface_data.row_scene
	
	# Create instance of the interface this component will be handling
	var interface_instance: Interface = interface_packed_scene.instantiate()
	# Connect the interface and this component together
	connected_interface = interface_instance
	interface_instance.interface_handler = self
	# Add interface to the scene node for interface ui components
	WorldComponentData.interface_ui.add_child(interface_instance)
	
	for page_to_make in page_count:
		# Create instance of page
		var page_instance: InterfacePage = page_packed_scene.instantiate()
		# Create page array
		var page: Array[Array] = []
		# Add page array to slot structure for access to slots
		interface_slots.append(page)
		# Add page instance to pages array to store reference to each page
		interface_pages.append(page_instance)
		# Add page instance to interface for storing in scene tree
		interface_instance.add_child(page_instance)
		
		for row_to_make in row_count:
			# Create instance of row
			var row_instance: InterfaceRow = row_packed_scene.instantiate()
			# Create row array
			var row: Array[InterfaceSlot] = []
			# Add row array to page in slot structure for access to slots
			page.append(row)
			# Add row instance to the rows within the currently being made page
			page_instance.row_container.add_child(row_instance)
			
			for slot_to_make in col_count:
				# Crate instance of slot
				var slot_instance: InterfaceSlot = slot_packed_scene.instantiate()
				# Add slot to row array in slot structure for access to it
				row.append(slot_instance)
				# Add page instance to the slots within the currently being made row
				row_instance.slot_container.add_child(slot_instance)
				# Connect slot instance to this node
				slot_instance.interface_handler = self


func SetupInitialData() -> void:
	if len(interface_pages) == 0:
		print("Error setting up interface " + str(connected_interface) + " with " + str(self) + ", no pages of slots made.")
		return
	
	amount_of_pages = page_count
	current_page_index = 0
	current_page = interface_pages[0]
	interface_is_open = false
	connected_interface.hide()


func OpenInterface() -> void:
	if interface_is_open:
		print("Interface " + str(connected_interface) + " already opened.")
		return
	interface_is_open = true
	MoveToFirstInterfacePage()
	connected_interface.show()
	player.RemoveControl()
	SaveLoadManager.ToggleSaveLoad("lock")


func CloseInterface() -> void:
	if !interface_is_open:
		print("Interface " + str(connected_interface) + " already closed.")
		return
	interface_is_open = false
	connected_interface.hide()
	player.ReturnControl()
	
	if has_item_in_cursor:
		RetrieveCursorData()
	
	SaveLoadManager.ToggleSaveLoad("unlock")


func RetrieveCursorData():
	var held_item_data = PreviewCursorHandler.held_data
	var held_item = held_item_data["item"]
	var held_amount = held_item_data["amount"]
	
	# Adds item held in cursor to first available slot in interface
	if IsThereSpaceInInterface() or IsItemInInterface(held_item):
		AddItemToInterface(held_item, held_amount)
		PreviewCursorHandler.RemovePreviewCursor()
	"""Add method for if no space left in interface aka, drop"""
	
	has_item_in_cursor = false


func ShowInterfacePage(page_num: int) -> void:
	if page_num < 0 or page_num >= len(interface_pages):
		print("Error showing page " + str(page_num) + " of interface " + str(connected_interface) + ", index is out of range. There are only " + str(amount_of_pages) + " pages.")
		return
	var page: InterfacePage = interface_pages[page_num]
	page.show()


func HideInterfacePages() -> void:
	for page in interface_pages:
		page.hide()


func MoveToInterfacePage(page_num: int) -> void:
	if page_num < 0 or page_num >= len(interface_pages):
		print("Error moving to page " + str(page_num) + " of interface " + str(connected_interface) + ", index is out of range. There are only " + str(amount_of_pages) + " pages.")
		return
	ChangePageToPage(page_num)


func MoveToNextInterfacePage() -> void:
	if amount_of_pages == 1:
		print("Error moving to next page of interface " + str(connected_interface) + ", there is only 1 page.")
		return
	
	# -1 to account for zero indexing, if current_page_index is equal to amount - 1, do not move
	# forwards, on final page
	if current_page_index < amount_of_pages - 1:
		ChangePageToPage(current_page_index + 1)


func MoveToPreviousInterfacePage() -> void:
	if amount_of_pages == 1:
		print("Error moving to previous page of interface " + str(connected_interface) + ", there is only 1 page.")
		return
	
	# Zero indexed, if current_page_index is equal to 0, do not move backwards, on first page
	if current_page_index > 0:
		ChangePageToPage(current_page_index - 1)


func MoveToFirstInterfacePage() -> void:
	# Zero indexed
	ChangePageToPage(0)


func MoveToLastInterfacePage() -> void:
	# Zero indexed
	ChangePageToPage(amount_of_pages - 1)


func ChangePageToPage(page_num: int) -> void:
	HideInterfacePages()
	current_page_index = page_num
	current_page = interface_pages[current_page_index]
	ShowInterfacePage(page_num)


func IsItemInInterface(item_name: String, on_current_page: bool = false) -> bool:
	if not on_current_page:
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


func IsThereSpaceInInterface(on_current_page: bool = false) -> bool:
	if not on_current_page:
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


# Internal function for repeated logic
func AddItemToInterface(item_name: String, item_amount: int, on_current_page: bool = false) -> void:
	# Adding to anywhere in interface
	if not on_current_page:
		# Adding item to an existing slot
		if IsItemInInterface(item_name):
			var slot_with_item: InterfaceSlot = FindFirstSlotWithItem(item_name)
			slot_with_item.IncreaseAmount(item_amount)
		
		# Adding item to an empty slot
		elif not IsItemInInterface(item_name):
			# If there is space
			if IsThereSpaceInInterface():
				# Add to first slot able to hold item
				var first_empty_slot: InterfaceSlot = FindFirstEmptySlot()
				first_empty_slot.SetItem(item_name)
				first_empty_slot.SetAmount(item_amount)
	
	# Adding to only this page
	elif on_current_page:
		# Adding item to an existing slot
		if IsItemInInterface(item_name, true):
			var slot_with_item: InterfaceSlot = FindFirstSlotWithItem(item_name, true)
			slot_with_item.IncreaseAmount(item_amount)
		
		# Adding item to an empty slot
		elif not IsItemInInterface(item_name, true):
			# If there is space
			if IsThereSpaceInInterface(true):
				# Add to first slot able to hold item
				var first_empty_slot: InterfaceSlot = FindFirstEmptySlot(true)
				first_empty_slot.SetItem(item_name)
				first_empty_slot.SetAmount(item_amount)


# Internal function for repeated logic
func IncreaseAmountInSlot(slot: InterfaceSlot, item_name: String, amount: int) -> void:
	# Cannot add an item to a slot that has a different item or no item
	if slot.item_name != item_name or slot.is_empty:
		print("Cannot increase amount of item " + item_name + " in slot " + str(slot) + ", its item is " + slot.item_name + ".")
		return
	
	slot.IncreaseAmount(amount)


# Internal function for repeated logic
func DecreaseAmountInSlot(slot: InterfaceSlot, item_name: String, amount: int) -> void:
	# Cannot take an item from a slot with a different item or no item
	if slot.item_name != item_name or slot.is_empty:
		print("Cannot decrease amount of item " + item_name + " in slot " + str(slot) + ", its item is " + slot.item_name + ".")
		return
	# Cannot take more items than present
	if amount > slot.amount:
		print("Cannot decrease amount of item " + item_name + " in slot " + str(slot) + ", it only has " + str(slot.amount) + " of that item.")
		return
		
	slot.DecreaseAmount(amount)


# External function to handle input into slots/interface
func AddExistingItemToSlot(slot_added_to: InterfaceSlot, item_name: String, amount: int, from_cursor: bool = false) -> void:
	var data = {"slot_added_to": slot_added_to, "item": item_name, "amount": amount, "price": slot_added_to.price}
	if not CanItemBeAddedToInterface(data):
		return
	
	# If not enough in cursor to add the given amount, return and stop
	if from_cursor and not PreviewCursorHandler.CanTakeAmountFromCursor(amount):
		return
	
	# Take item from cursor and add to the slot
	if from_cursor: 
		PreviewCursorHandler.ReduceAmountOfItemInCursor(amount)
	IncreaseAmountInSlot(slot_added_to, item_name, amount)
	
	# Handle events occuring on items being exchanged between interfaces
	HandleItemAddedToInterface(data)


# External function to handle input into slots/interface
func AddNewItemToSlot(slot_added_to: InterfaceSlot, item_name: String, amount: int, from_cursor: bool = false) -> void:
	var data = {"slot_added_to": slot_added_to, "item": item_name, "amount": amount, "price": slot_added_to.price}
	if not CanItemBeAddedToInterface(data):
		return
	
	# If cannot take given amount from cursor, return and stop
	if from_cursor and not PreviewCursorHandler.CanTakeAmountFromCursor(amount):
		return
	
	# If item already in slot, return and stop. Need to do swap function instead
	if not slot_added_to.is_empty:
		print("Cannot add " + item_name + " to slot " + str(slot_added_to) + ", it already has an item.")
		return
	
	# Take amount of item from cursor and setup the slot with that item and amount
	if from_cursor:
		PreviewCursorHandler.ReduceAmountOfItemInCursor(amount)
	slot_added_to.SetItem(item_name)
	slot_added_to.SetAmount(amount)
	
	# Handle events occuring on items being exchanged between interfaces
	HandleItemAddedToInterface(data)


# External function to handle output of an item into cursor and input into slots/interface
func SwapItemsOfCursorAndSlot(slot: InterfaceSlot) -> void:
	# Can only complete a swap if either the cursor or the slot are empty
	if slot.is_empty or PreviewCursorHandler.cursor_packed_scene == null:
		print("Cannot switch items of slot " + str(slot) + " and cursor. One of them is empty.")
		return
	
	if not PreviewCursorHandler.held_data.has("item") or not PreviewCursorHandler.held_data.has("amount"):
		print("Cannot switch items of slot " + str(slot) + " and cursor. Missing data of some kind in preview cursor held data.")
		return
	
	# Access data in more usable format
	var slot_item: String = slot.item_name
	var slot_amount: int = slot.amount
	var cursor_item: String = PreviewCursorHandler.held_data["item"]
	var cursor_amount: int = PreviewCursorHandler.held_data["amount"]
	
	var cursor_data = {"slot_added_to": slot, "item": cursor_item, "amount": cursor_amount}
	var data = {"slot_taken_from": slot, "item": slot_item, "amount": slot_amount}
	if not CanItemBeAddedToInterface(cursor_data) or not CanItemBeTakenFromInterface(data):
		return
	
	# Switch item in preview cursor
	PreviewCursorHandler.held_data["source"].has_item_in_cursor = false
	PreviewCursorHandler.RemovePreviewCursor()
	var new_cursor_data = {"item": slot_item, "amount": slot_amount, "source": self}
	PreviewCursorHandler.CreatePreviewCursor(slot.slot_icon.texture, new_cursor_data)
	has_item_in_cursor = true
	
	# Switch item in slot
	slot.RemoveItem()
	slot.SetItem(cursor_item)
	slot.SetAmount(cursor_amount)
	
	HandleItemRemovedFromInterface(data)
	HandleItemAddedToInterface(cursor_data)


func MoveItemFromSlotToCursor(slot: InterfaceSlot, amount: int) -> void:
	if slot.is_empty:
		print("Error moving item from slot " + str(slot) + " into cursor. No item in slot.")
		return
	if PreviewCursorHandler.held_data.has("item") and PreviewCursorHandler.held_data["item"] != slot.item_name:
		print("Error moving item from slot " + str(slot) + " into cursor. Item in cursor not the same as the one in the slot.")
		return
	if amount > slot.amount:
		print("Error taking " + str(amount) + " of item from slot " + str(slot) + ", it only has " + str(slot.amount) + " of it.")
		return
	var data = {"slot_taken_from": slot, "item": slot.item_name, "amount": amount, "price": slot.price}
	if not CanItemBeTakenFromInterface(data):
		return
	
	# Either create a new cursor or add the item in 
	if PreviewCursorHandler.data_preview_cursor == null:
		var cursor_data = {"item": slot.item_name, "amount": amount, "source": self}
		PreviewCursorHandler.CreatePreviewCursor(slot.slot_icon.texture, cursor_data)
		has_item_in_cursor = true
	else:
		PreviewCursorHandler.IncreaseAmountOfItemInCursor(amount)
	
	slot.DecreaseAmount(amount)
	
	HandleItemRemovedFromInterface(data)


# Function Information - Overriden by Child Classes
# Use - Interface Use
# Does - Returns whether the given amount of the given item can be taken from the interface.
#		In child classes, will check for time completion or item costs for example.
@warning_ignore("unused_parameter")
func CanItemBeTakenFromInterface(data: Dictionary) -> bool:
	return true


# Function Information - Overriden by Child Classes
# Use - Interface Use
# Does - Returns whether the given amount of the given item can be added to the interface.
#		In child classes, will check for valid items for example.
@warning_ignore("unused_parameter")
func CanItemBeAddedToInterface(data: Dictionary) -> bool:
	return true


# Function Information - Overriden by Child Classes
# Use - Interface Use
# Does - Completes appropiate logic for adding items to an interface. In child classes, will
#		start a process timer, add to inventory or give the player currency for example.
@warning_ignore("unused_parameter")
func HandleItemAddedToInterface(data: Dictionary) -> void:
	pass


# Function Information - Overriden by Child Classes
# Use - Interface Use
# Does - Completes appropiate logic for taking items from an interface. In child classes, will
#		remove from inventory or take the player's currency for example.
@warning_ignore("unused_parameter")
func HandleItemRemovedFromInterface(data: Dictionary) -> void:
	pass


func FindIndexOfSlotInInterface(slot: InterfaceSlot) -> Array[int]:
	for page_index in range(len(interface_slots)):
		for row_index in range(len(interface_slots[page_index])):
			for slot_index in range(len(interface_slots[page_index][row_index])):
				if slot == interface_slots[page_index][row_index][slot_index]:
					return [page_index, row_index, slot_index]
	return []


func GetSaveData() -> Dictionary:
	var save_data = {
		"slot_items": GetSlotItems(),
		"slot_amounts": GetSlotAmounts(),
	}
	return save_data


func ApplyLoadedData(loaded_save_data: Dictionary) -> void:
	var applied = ["slot_items", "slot_amounts"]	
	SaveLoadManager.CheckLoadedDataIsValid(applied, loaded_save_data.keys(), self)
	
	if loaded_save_data.has("slot_items") and loaded_save_data.has("slot_amounts"):
		RecreateLoadedInterface(loaded_save_data["slot_items"], loaded_save_data["slot_amounts"])


func GetSlotItems() -> Array[Array]:
	var reference_array: Array[Array] = []
	for page in interface_slots:
		var reference_page: Array[Array] = []
		reference_array.append(reference_page)
		for row in page:
			var reference_row: Array[String] = []
			reference_page.append(reference_row)
			for slot in row:
				slot = slot as InterfaceSlot
				if slot.is_empty:
					reference_row.append("")
				else:
					reference_row.append(slot.item_name)
	return reference_array


func GetSlotAmounts() -> Array[Array]:
	var reference_array: Array[Array] = []
	for page in interface_slots:
		var reference_page: Array[Array] = []
		reference_array.append(reference_page)
		for row in page:
			var reference_row: Array[int] = []
			reference_page.append(reference_row)
			for slot in row:
				slot = slot as InterfaceSlot
				if slot.is_empty:
					reference_row.append(0)
				else:
					reference_row.append(slot.amount)
	return reference_array


func RecreateLoadedInterface(item_reference_array: Array, amount_reference_array: Array) -> void:
	for page_index in range(len(item_reference_array)):
		for row_index in range(len(item_reference_array[page_index])):
			for slot_index in range(len(item_reference_array[page_index][row_index])):
				# Access information in a more easy to use format
				var slot_item = item_reference_array[page_index][row_index][slot_index]
				var slot_amount = amount_reference_array[page_index][row_index][slot_index]
				var interface_slot: InterfaceSlot = interface_slots[page_index][row_index][slot_index]
				
				# Clear currently stored item in slot ready for loaded data
				interface_slot.RemoveItem()
				
				# Can only set item if have both an amount and item reference
				if slot_item == "" and slot_amount != 0:
					print("Error when loading interface of handler " + str(self) + ", a slot has a set amount but not an item.")
					continue
				if slot_item != "" and slot_amount == 0:
					print("Error when loading interface of handler " + str(self) + ", a slot has a set item but not an amount.")
					continue
				
				# Set item and amount of slot if given both
				if slot_item != "":
					interface_slot.SetItem(slot_item)
					interface_slot.SetAmount(slot_amount)
