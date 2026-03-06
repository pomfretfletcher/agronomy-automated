extends Node

var game_speed: float = 1000.0

var total_game_time: float = 0.0
var today_time: float = 0.0
var current_minute: int = 0
var current_day: int = 0

signal minute_passed(day: int, hour: int, minute: int)
signal day_passed(day: int)

func _process(delta: float) -> void:
	total_game_time += delta * game_speed * Constants.GAME_MINUTE_DURATION
	today_time += delta * game_speed * Constants.GAME_MINUTE_DURATION
	calculate_time()
	
func calculate_time() -> void:
	var today_minutes: int = int(today_time / Constants.GAME_MINUTE_DURATION)
	var today_hours: int = int(today_minutes / Constants.MINUTES_PER_HOUR)
	var day: int = int(total_game_time / Constants.GAME_MINUTE_DURATION / Constants.MINUTES_PER_DAY)
	var minute: int = int(today_minutes % Constants.MINUTES_PER_HOUR)
	var hour: int = int(today_minutes / Constants.MINUTES_PER_HOUR)
	
	if current_minute != today_minutes:
		current_minute = today_minutes
		minute_passed.emit(day, today_hours, today_minutes)
	
	if current_day != day:
		today_time = 0
		current_day = day
		day_passed.emit(day)
