class_name CropHarvestComponent
extends TileComponent

@export var crop_fields: Node2D
@export var crop_planting_component: CropPlantingComponent

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("harvest_crop"):
		GetCellInFrontOfPlayer()
		HarvestCrop()

func HarvestCrop() -> void:
	var crop_nodes = crop_fields.get_children()
		
	for node: Node2D in crop_nodes:
		if node.global_position == local_cell_position:
			var crop = node as Crop
			var harvested = crop.OnHarvest()
			if harvested:
				crop_planting_component.planted_crops.erase(cell_position)
