class_name StorageInterface
extends Interface

var storage_slots: Array[Array]
@export var horizontal_slot_count: int
@export var vertical_slot_count: int
@onready var player: Player = get_tree().get_first_node_in_group("player")
@export var row_container: VBoxContainer
@export var slot_item_assignment_component: SlotItemAssignmentComponent

var row_framework: PackedScene
var slot_framework: PackedScene

func OpenInterface() -> void:
	show()
	is_opened = true
	if player != null: player.RemoveControl()

func CloseInterface() -> void:
	hide()
	is_opened = false
	if player != null: player.ReturnControl()

func SetupInterface() -> void:
	for x in range(vertical_slot_count):
		var row: Array[Slot] = []
		for y in range(horizontal_slot_count):
			var new_slot: InterfaceSlot = slot_framework.instantiate() as InterfaceSlot
			new_slot.slot_item_assignment_component = slot_item_assignment_component
			new_slot.interface = self
			row.append(new_slot)
		storage_slots.append(row)
		
		var row_node: PanelContainer = row_framework.instantiate()
		var row_margin_container = row_node.get_child(0).get_child(0)
		for slot in row:
			row_margin_container.add_child(slot)
		row_container.add_child(row_node)
	
	if slot_item_assignment_component != null:
		slot_item_assignment_component.current_slots = storage_slots
	
	hide()
