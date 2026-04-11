class_name CropSwayComponent
extends Node2D

@onready var parent_crop: Crop = $".."
var crop_data: CropData
var current_degree: float = 0
var sway_direction: int = 1
var randomised_sway_speed: float
var randomised_max_sway_degree: float

func _ready() -> void:
	crop_data = Database.database[parent_crop.internal_name]
	# Provide some level of randomness to each crop - different each time game loaded
	randomised_sway_speed = randf_range(crop_data.sway_speed * 0.8, crop_data.sway_speed * 1.2)
	randomised_max_sway_degree = randf_range(crop_data.max_sway_degree * 0.8, crop_data.max_sway_degree * 1.2)
	
func _process(delta: float) -> void:
	current_degree = current_degree + delta * sway_direction * randomised_sway_speed
	parent_crop.skew = deg_to_rad(current_degree)

	if current_degree > randomised_max_sway_degree or current_degree < -randomised_max_sway_degree:
		sway_direction *= -1
	
