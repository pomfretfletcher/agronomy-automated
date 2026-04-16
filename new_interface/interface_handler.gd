class_name InterfaceHandler
extends Node

var connected_interface: Interface
@export var interface_internal_name: String

# A 3D array consisting of each page of the interface's slots. Fe a building with two pages of
# 3x5 slot structure would be be a 2x3x5 Array[Array[Array[Slot]]]
var interface_slots: Array[Array]

var interface_pages: Array[Interface]

@export var page_count: int
@export var row_count: int
@export var col_count: int

func _ready() -> void:
	SetupInterfaceDisplay()
	
func SetupInterfaceDisplay() -> void:
	var interface_data = Database.database[interface_internal_name] as InterfaceData
	var page_packed_scene = interface_data.page_scene
	var slot_packed_scene = interface_data.slot_scene
	var row_packed_scene = interface_data.row_scene
	
	for page_to_make in page_count:
		# Construct page
		var page_instance: InterfacePage = page_packed_scene.instantiate()
		var page: Array[Array] = []
		interface_pages.append(page)
		
		for row_to_make in row_count:
			# Construct rows
			var row_instance: PanelContainer = row_packed_scene.instantiate()
			var row: Array[Array] = []
			page.append(row)
			page_instance.add_child(row_instance)
			
			for slot_to_make in col_count:
				# Construct slots
				var slot_instance: InterfaceSlot = slot_packed_scene.instantiate()
				row.append(slot_instance)
				row_instance.add_child(slot_instance)
				
