class_name CropDisplayComponent
extends MouseComponent

var displaying: bool = true

@export var crop_fields: Node2D
@export var crop_display_interface: CropDisplayInterface

@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	GetTargetedCell()

	if displaying == false:
		crop_display_interface.visible = false
		return
		
	var crop_nodes = crop_fields.get_children()
	
	var viewing_crop = false
	for node: Node2D in crop_nodes:
		if node.global_position == local_cell_position:
			viewing_crop = true
			
			var crop: Crop = node as Crop
			var cgc: CropGrowthComponent = crop.crop_growth_component
				
			var growth_decimal: float = snapped((float(cgc.growth_progress) / float(cgc.growth_total)), 0.01)
			var growth_percent: int = (int)(100 * growth_decimal)
			var cdi: CropDisplayInterface = crop_display_interface
			cdi.name_label.text = crop.crop_name
			cdi.percent_label.text = str(growth_percent) + "%"
			cdi.position = local_cell_position - Vector2(cdi.size.x / 2, cdi.size.y + 16)
			cdi.visible = true
		
	if not viewing_crop:
		crop_display_interface.visible = false

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("alternate_crop_info"):
		if displaying:
			displaying = false
		else:
			displaying = true
