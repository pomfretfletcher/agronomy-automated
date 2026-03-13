class_name CropGrowthComponent
extends Node2D

@onready var sprite_2d: Sprite2D = $"../Sprite2D"
@onready var parent_crop: Crop = $".."

@export var growth_sprite_amount: int = 5
@export var base_growth_days: int = 0
var growth_per_minute: int = 100
var growth_total_per_day: int = 100 * Constants.MINUTES_PER_DAY
var growth_total: int = 0
var growth_progress: int = 0
var current_growth_sprite: int = 0

func _ready() -> void:
	TimeManager.minute_passed.connect(OnMinutePassed)
	CalculateGrowth()
	
func CalculateGrowth() -> void:
	growth_total = growth_total_per_day * base_growth_days
	
func OnMinutePassed(day: int, hour: int, minute: int) -> void:
	if (growth_progress < growth_total) and parent_crop.is_watered:
		var growth_amount: int = FactorInExternalGrowthChanges()
		growth_progress += growth_amount
		DecideSprite()

func FactorInExternalGrowthChanges() -> int:
	return growth_per_minute
	
func DecideSprite() -> void:
	var frame = int(growth_progress / (growth_total / growth_sprite_amount))
	sprite_2d.frame = frame if frame < growth_sprite_amount else growth_sprite_amount - 1
