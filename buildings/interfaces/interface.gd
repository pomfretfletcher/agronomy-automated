class_name Interface
extends PanelContainer

@export var internal_name: String
var is_opened: bool = false
var lock_open_close: bool = false
var being_used_in_interface_interaction: bool = false

@export var horizontal_slot_count: int
@export var vertical_slot_count: int
@onready var player: Player = get_tree().get_first_node_in_group("player")
@onready var row_container: VBoxContainer = $MarginContainer/VBoxContainer
@export var slot_item_assignment_component: SlotItemAssignmentComponent

@warning_ignore("unused_signal")
signal full_stack_movement(data)
@warning_ignore("unused_signal")
signal single_item_movement(data)

var row_framework: PackedScene
var slot_framework: PackedScene

# Function Information
# Use - Interface Use
# Does - Sets internal state, visibility and external states to appropiate game state
# Debug - N/A
func OpenInterface() -> void:
	show()
	is_opened = true
	if player != null: player.RemoveControl()
	Statuses.ToggleSaveLoad("lock")

# Function Information
# Use - Interface Use
# Does - Sets internal state, visibility and external states to appropiate game state
# Debug - N/A
func CloseInterface() -> void:
	hide()
	is_opened = false
	if player != null: player.ReturnControl()
	Statuses.ToggleSaveLoad("unlock")

# Function Information
# Use - Interface Use
# Does - Creates the required slots for the interface and sets their internal references
# Debug - N/A
func SetupInterface() -> void:
	for y in range(vertical_slot_count):
		var row: Array[Slot] = []
		for x in range(horizontal_slot_count):
			var new_slot: InterfaceSlot = slot_framework.instantiate() as InterfaceSlot
			new_slot.slot_item_assignment_component = slot_item_assignment_component
			new_slot.interface = self
			row.append(new_slot)
		slot_item_assignment_component.current_slots.append(row)
		
		var row_node: PanelContainer = row_framework.instantiate()
		var row_margin_container = row_node.get_child(0).get_child(0)
		for slot in row:
			row_margin_container.add_child(slot)
		row_container.add_child(row_node)

# Function Information
# Use - Interface Saving
# Does - Returns an array with the item names positioned within the interface's slots
# Debug - N/A
func GetSlotReferences() -> Array:
	var reference_array: Array
	# Create reference array with empty values that will be returned
	for y in range(vertical_slot_count):
		var row: Array[String] = []
		for x in range(horizontal_slot_count):
			row.append("")
		reference_array.append(row)
	
	# Sets each value in the array equal to the corresponding item name in the slots of the interface
	var slotcomp = slot_item_assignment_component
	for row_index in range(len(slotcomp.current_slots)):
		for col_index in range(len(slotcomp.current_slots[row_index])):
			var cur_slot = slotcomp.current_slots[row_index][col_index] as InterfaceSlot
			if !cur_slot.is_empty:
				reference_array[row_index][col_index] = cur_slot.item_name
	return reference_array
