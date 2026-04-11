class_name CropGrowthComponent
extends Node2D

@onready var sprite_2d: Sprite2D = $"../Sprite2D"
@onready var parent_crop: Crop = $".."
var crop_data: CropData

var growth_total: int = 0
var growth_progress: int = 0

# Function Information
# Use - Crop Growth
# Does - Grabs data for specific crop attached to, connects appropiate signals, then calculates how much 
#		required to grow
# Debug - N/A
func _ready() -> void:
	crop_data = Database.database[parent_crop.internal_name]
	TimeManager.minute_passed.connect(OnMinutePassed)
	CalculateGrowth()

# Function Information
# Use - Crop Growth
# Does - Calculates how much/long the crop will have to grow
# Debug - N/A
func CalculateGrowth() -> void:
	growth_total = (int)(GlobalData.crop_growth_per_minute * Constants.MINUTES_PER_DAY * crop_data.base_growth_days)

# Function Information
# Use - Crop Growth
# Does - Grows the crop by a certain amount each minute if able to grow, then updates sprites
# Debug - N/A
func OnMinutePassed() -> void:
	if (growth_progress < growth_total) and parent_crop.is_watered:
		var growth_amount: int = FactorInExternalGrowthChanges()
		growth_progress += growth_amount
	DecideSprite()

# Function Information
# Use - Crop Growth
# Does - Decides how much crop will grow each minute
# Debug - N/A
func FactorInExternalGrowthChanges() -> int:
	return GlobalData.crop_growth_per_minute

# Function Information
# Use - Crop Growth
# Does - Decides the frame the crop will be at each time it grows
# Debug - N/A
func DecideSprite() -> void:
	var frame: int = int(growth_progress / (float(growth_total) / crop_data.sprite_count))
	sprite_2d.frame = frame if frame < crop_data.sprite_count else crop_data.sprite_count - 1
