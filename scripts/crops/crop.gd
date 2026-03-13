class_name Crop
extends Node2D

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var watering_particles: GPUParticles2D = $WateringParticles
@onready var hurt_component: HurtComponent = $HurtComponent
@onready var crop_growth_component: CropGrowthComponent = $CropGrowthComponent

@export var crop_name: String
@export var dropped_item_framework: PackedScene
@export var dropped_item_name: String

var is_watered: bool = false
var watering_animation_time: float = 3.0

func _ready() -> void:
	watering_particles.emitting = false
	
	hurt_component.hurt.connect(OnWater)
	
func OnWater(hit_damage: int) -> void:
	watering_particles.emitting = true
	await get_tree().create_timer(watering_animation_time).timeout
	watering_particles.emitting = false
	is_watered = true
	
func OnHarvest() -> bool:
	if crop_growth_component.growth_progress >= crop_growth_component.growth_total:
		var item_instance = dropped_item_framework.instantiate() as Item
		item_instance.global_position = global_position
		item_instance.ChangeItemName(dropped_item_name)
		item_instance.ChangeItemSprite(NameTextureDictionary.texture_dictionary.get(dropped_item_name))
		get_parent().get_parent().add_child(item_instance)
		queue_free()
		return true
	else:
		return false
