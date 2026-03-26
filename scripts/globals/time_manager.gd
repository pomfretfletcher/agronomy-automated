extends Node

var game_speed: float = 200.0

var total_game_time: float = 0.0
var today_time: float = 0.0
var current_minute: int = 0
var current_day: int = 0

signal minute_passed_with_parameters(day: int, hour: int, minute: int)
signal day_passed_with_parameters(day: int)
signal minute_passed
signal day_passed

func _process(delta: float) -> void:
	total_game_time += delta * game_speed * Constants.GAME_MINUTE_DURATION
	today_time += delta * game_speed * Constants.GAME_MINUTE_DURATION
	calculate_time()
	
func calculate_time() -> void:
	var _today_minutes: int = int(today_time / float(Constants.GAME_MINUTE_DURATION))
	var _today_hours: int = int(_today_minutes / float(Constants.MINUTES_PER_HOUR))
	var _day: int = int(total_game_time / float(Constants.GAME_MINUTE_DURATION) / float(Constants.MINUTES_PER_DAY))
	var _minute: int = _today_minutes % Constants.MINUTES_PER_HOUR
	var _hour: int = int(_today_minutes / float(Constants.MINUTES_PER_HOUR))
	
	if current_minute != _today_minutes:
		current_minute = _today_minutes
		minute_passed.emit()
		minute_passed_with_parameters.emit(_day, _hour, _minute)
	
	if current_day != _day:
		today_time = 0
		current_day = _day
		day_passed.emit()
		day_passed_with_parameters.emit(_day)
