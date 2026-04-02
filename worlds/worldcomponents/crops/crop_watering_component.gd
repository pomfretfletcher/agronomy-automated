class_name CropWateringComponent
extends TileComponent

@export var watered_soil_component: WateredSoilComponent
var watering_particles_framework: PackedScene = ReusedPackedSceneDictionary.packed_scene_dictionary["watering_particles_framework"]
@export var watering_animation_time: float = 3.0
var tiles_emitting_in: Array[Vector2i]

func _unhandled_input(event: InputEvent) -> void:
	if !player.can_use_tools:
		return
		
	if event.is_action_pressed("use_tool"):
		if ToolManager.selected_tool == DataTypes.Tools.WateringCan:
			GetCellInFrontOfPlayer()
			WaterCrop()

func WaterCrop() -> void:
	if WorldComponentData.planted_crops.has(cell_position):
		WorldComponentData.planted_crops[cell_position].OnWater()
	if cell_position not in WorldComponentData.watered_tiles:
		watered_soil_component.WaterTile(cell_position)
	if cell_position not in tiles_emitting_in:
		tiles_emitting_in.append(cell_position)
		call_deferred("SpawnWaterParticles", local_cell_position, cell_position)
	
func SpawnWaterParticles(spawn_position: Vector2, tile_position: Vector2i) -> void:
	# Spawn particles at world position
	var particle_instance: GPUParticles2D = watering_particles_framework.instantiate()
	add_child(particle_instance)
	particle_instance.global_position = spawn_position
	
	# After animation finishes, remove reference and delete instance
	await get_tree().create_timer(watering_animation_time).timeout
	tiles_emitting_in.erase(tile_position)
	particle_instance.queue_free()
