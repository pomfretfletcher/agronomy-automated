extends Node

var game_speed: float = 100.0

var total_game_time: float = 0.0
var today_time: float = 0.0
var current_minute: int = 0
var current_day: int = 1
var starting_day: int = 1
var year_length: int = 0

signal minute_passed_with_parameters(day: int, hour: int, minute: int)
signal day_passed_with_parameters(day: int)
signal minute_passed
signal day_passed

# Information
# Use - Internal
# By - Game Startup
# For - Initialises data
# Explanation -
#	Calls decide year length method next frame (so all data will be ready for it)
# Debug - N/A
func _ready() -> void:
	call_deferred("DecideYearLength")
	
func DecideYearLength():
	year_length = SeasonManager.season_length * len(DataTypes.Seasons.keys())
	
func _process(delta: float) -> void:
	total_game_time += delta * game_speed * Constants.GAME_MINUTE_DURATION
	today_time += delta * game_speed * Constants.GAME_MINUTE_DURATION
	calculate_time()

@warning_ignore("unused_variable")
func calculate_time() -> void:
	var today_minutes: int = int(today_time / float(Constants.GAME_MINUTE_DURATION))
	#var today_hours: int = int(today_minutes / float(Constants.MINUTES_PER_HOUR))
	var day: int = int(total_game_time / float(Constants.GAME_MINUTE_DURATION) / float(Constants.MINUTES_PER_DAY)) + starting_day
	var minute: int = today_minutes % Constants.MINUTES_PER_HOUR
	var hour: int = int(today_minutes / float(Constants.MINUTES_PER_HOUR))
	
	if current_minute != today_minutes:
		current_minute = today_minutes
		minute_passed.emit()
		minute_passed_with_parameters.emit(day, hour, minute)
	
	if current_day != day and day != starting_day:
		today_time = 0
		current_day = day
		day_passed.emit()
		day_passed_with_parameters.emit(day)
