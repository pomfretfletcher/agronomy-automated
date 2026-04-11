extends Node

var game_speed: float = 100.0
var year_length: int = 0

var starting_day: int = 1
var starting_hour: int = 6
var starting_minute: int = 30

var total_game_time: float = 0.0
var today_time: float = 0.0

var current_minute: int = 0
var current_day: int = 0
var current_year: int = 1
var current_day_this_year: int = 0

signal minute_passed_with_parameters(day: int, hour: int, minute: int)
signal day_passed_with_parameters(day: int)
signal minute_passed
signal day_passed

# Function Information
# Use - Game Time
# Does - Set initial value of time for a translated starting time, then decides how long years will be
# Debug - N/A
func _ready() -> void:
	call_deferred("DecideYearLength")
	if starting_minute != 0:
		total_game_time += starting_minute * Constants.GAME_MINUTE_DURATION
	if starting_hour != 0:
		total_game_time += starting_hour * Constants.MINUTES_PER_HOUR * Constants.GAME_MINUTE_DURATION
	today_time = total_game_time
	current_day = starting_day

# Function Information
# Use - Game Time
# Does - Calculates how long year will last
# Debug - N/A
func DecideYearLength():
	year_length = SeasonManager.season_length * len(DataTypes.Seasons.keys())

# Function Information
# Use - Game Time
# Does - Tick time each frame based on time between frames and game speed
# Debug - N/A
func _process(delta: float) -> void:
	total_game_time += delta * game_speed * Constants.GAME_MINUTE_DURATION
	today_time += delta * game_speed * Constants.GAME_MINUTE_DURATION
	CalculateTime()

# Function Information
# Use - Game Time
# Does - Find the exact day, minute and hour that have passed total in game, then the minute and hour on today.
#		Then emit signals once thresholds of hours, minutes and days are passed
# Debug - N/A
func CalculateTime() -> void:
	var today_minutes: int = int(today_time / float(Constants.GAME_MINUTE_DURATION))
	#var today_hours: int = int(today_minutes / float(Constants.MINUTES_PER_HOUR))
	var day: int = int(total_game_time / float(Constants.GAME_MINUTE_DURATION) / float(Constants.MINUTES_PER_DAY)) + starting_day
	var minute: int = today_minutes % Constants.MINUTES_PER_HOUR
	var hour: int = int(today_minutes / float(Constants.MINUTES_PER_HOUR))
	
	if current_minute != today_minutes:
		# Store value of how many minutes have passed this day
		current_minute = today_minutes
		
		# Emit signal with exact irl translated time
		minute_passed.emit()
		minute_passed_with_parameters.emit(day, hour, minute)
	
	if current_day != day and day != starting_day:
		# Year passed
		if day % year_length == 0:
			current_year += 1
			current_day_this_year = 0
			
		# Reset time of this day
		today_time = 0
		
		# Iterate day count
		current_day_this_year += 1
		current_day = day
		
		# Emit signals
		day_passed.emit()
		day_passed_with_parameters.emit(day)

func GetSaveData() -> Dictionary:
	var save_data = {
		"total_game_time": total_game_time,
		"today_time": today_time,
		"current_year": current_year,
		"current_day": current_day,
		"current_day_this_year": current_day_this_year,
		"current_minute": current_minute
	}
	return save_data

func ApplyLoadedData(loaded_save_data: Dictionary) -> void:
	var applied = ["total_game_time", "today_time", "current_year", "current_day", "current_day_this_year", "current_minute"]	
	SaveLoadManager.CheckLoadedDataIsValid(applied, loaded_save_data.keys(), self)
	
	if loaded_save_data.has("total_game_time"): total_game_time = loaded_save_data["total_game_time"]
	if loaded_save_data.has("today_time"): today_time = loaded_save_data["today_time"]
	if loaded_save_data.has("current_year"): current_year = loaded_save_data["current_year"]
	if loaded_save_data.has("current_day"): current_day = loaded_save_data["current_day"]
	if loaded_save_data.has("current_day_this_year"): current_day_this_year = loaded_save_data["current_day_this_year"]
	if loaded_save_data.has("current_minute"): current_minute = loaded_save_data["current_minute"]
