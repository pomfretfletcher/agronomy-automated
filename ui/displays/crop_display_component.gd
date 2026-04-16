class_name CropDisplayComponent
extends MouseComponent

var displaying: bool = true

@export var crop_fields: Node2D
@export var display: CropDisplayInterface


func _process(_delta: float) -> void:
	GetTargetedCell()

	if displaying == false:
		display.visible = false
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
			display.name_label.text = Database.database[crop.internal_name].display_name
			display.percent_label.text = str(growth_percent) + "%"
			display.position = local_cell_position - Vector2(display.size.x / 2, display.size.y + 16)
			display.visible = true
		
	if not viewing_crop:
		display.visible = false


# Information
# Use - External
# By - Player Input Map
# For - Either starts or stops displaying crop info interface
# Explanation -
#	If correct input:
#		Toggle displaying
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("alternate_crop_info"):
		if displaying:
			displaying = false
		else:
			displaying = true
