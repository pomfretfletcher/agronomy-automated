class_name CropGrowthComponent
extends Node2D

@export var sprite_2d: Sprite2D
@export var parent_crop: Crop

@export var growth_sprite_amount: int = 5
@export var base_growth_days: float = 1.0
var growth_per_minute: int = 100
var growth_total_per_day: int = 100 * Constants.MINUTES_PER_DAY
var growth_total: int = 0
var growth_progress: int = 0
var current_growth_sprite: int = 0

# Information
# Use - Internal
# By - Game Startup
# For - Initialises data
# Explanation -
#	Connects time passing signal from time manager
#	Calculate how much progress it will take to grow the crop
# Debug - N/A
func _ready() -> void:
	TimeManager.minute_passed.connect(OnMinutePassed)
	CalculateGrowth()
	
func CalculateGrowth() -> void:
	growth_total = (int)(growth_total_per_day * base_growth_days)
	
func OnMinutePassed() -> void:
	if (growth_progress < growth_total) and parent_crop.is_watered:
		var growth_amount: int = FactorInExternalGrowthChanges()
		growth_progress += growth_amount
	DecideSprite()

func FactorInExternalGrowthChanges() -> int:
	return growth_per_minute
	
func DecideSprite() -> void:
	var frame: int = int(growth_progress / (float(growth_total) / growth_sprite_amount))
	sprite_2d.frame = frame if frame < growth_sprite_amount else growth_sprite_amount - 1
