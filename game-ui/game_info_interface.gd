extends PanelContainer

@export var time_label: Label
@export var day_label: Label
@export var year_label: Label

# Function Information
# Use - Game UI
# Does - Connect signals, show on UI
# Debug - N/A
func _ready() -> void:
	TimeManager.minute_passed_with_parameters.connect(UpdateLabels)
	show()

# Function Information
# Use - Game UI
# Does - Keep labels in parity with global time, season values
# Debug - N/A
func UpdateLabels(day: int, hour: int, minute: int) -> void:
	# Constructs time label to always have 4 digits, with 0's making up space to keep length of time label
	time_label.text = ""
	if len(str(hour)) == 1:
		time_label.text += ("0" + str(hour))
	else:
		time_label.text += str(hour)
	time_label.text += ":"
	if len(str(minute)) == 1:
		time_label.text += ("0" + str(minute))
	else:
		time_label.text += str(minute)
	
	# Sets season/daya label to current season and day of that season
	var cur_season = DataTypes.Seasons.find_key(SeasonManager.current_season) as String
	cur_season = cur_season.to_pascal_case()
	var cur_day = day % (SeasonManager.season_length) + (SeasonManager.season_length if day % SeasonManager.season_length == 0 else 0)
	day_label.text = str(cur_season) + " " + str(cur_day)
	
	# Sets year label to the current in game year
	year_label.text = "Year " + str(TimeManager.current_year)
