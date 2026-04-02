extends PanelContainer

@export var time_label: Label
@export var day_label: Label

# Information
# Use - Internal
# By - Game Startup
# For - Initialises data
# Explanation -
#	Connects appropiate methods to time manager signals
# Debug - N/A
func _ready() -> void:
	TimeManager.minute_passed_with_parameters.connect(UpdateLabels)

func UpdateLabels(day: int, hour: int, minute: int) -> void:
	time_label.text = str(hour) + ":" + str(minute)
	
	var cur_season = DataTypes.Seasons.find_key(SeasonManager.current_season)
	var cur_day = day % (SeasonManager.season_length) + (1 if day > SeasonManager.season_length else 0)
	day_label.text = str(cur_season) + " " + str(cur_day)
