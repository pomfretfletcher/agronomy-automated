class_name StorageInterface
extends PanelContainer

var storage_slots: Array[Array]
var is_opened: bool = false
@export var horizontal_slot_count: int
@export var vertical_slot_count: int
@export var inventory_slot_framework: PackedScene
@export var inventory_row_framework: PackedScene
@onready var row_container: VBoxContainer = $MarginContainer/VBoxContainer
@onready var slot_item_assignment_component: SlotItemAssignmentComponent = $SlotItemAssignmentComponent

func _ready() -> void:
	for x in range(vertical_slot_count):
		var row: Array[InventorySlot] = []
		for y in range(horizontal_slot_count):
			var slot: InventorySlot = inventory_slot_framework.instantiate() as InventorySlot
			row.append(slot)
		
		var row_node: PanelContainer = inventory_row_framework.instantiate()
		var row_margin_container = row_node.get_child(0).get_child(0)
		for slot in row:
			row_margin_container.add_child(slot)
		row_container.add_child(row_node)
	
	slot_item_assignment_component.current_slots = storage_slots
