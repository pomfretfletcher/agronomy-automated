class_name CropHarvestComponent
extends MouseComponent

@export var crop_fields: Node2D

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("harvest_crop"):
		GetTargetedCell()
		HarvestCrop()

func HarvestCrop() -> void:
	if distance < mouse_reach:
		var crop_nodes = crop_fields.get_children()
		
		for node: Node2D in crop_nodes:
			if node.global_position == local_cell_position:
				var crop = node as Crop
				crop.OnHarvest()
