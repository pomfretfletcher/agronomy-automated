extends Node

var starting_season: DataTypes.Seasons = DataTypes.Seasons.Spring
var current_season: DataTypes.Seasons
var season_length: int = 30

# Information
# Use - Internal
# By - Game Startup
# For - Initialises data
# Explanation -
#	Sets initial current season value
#	Connects internal check function to time passed signal
# Debug - N/A
func _ready() -> void:
	current_season = starting_season
	TimeManager.day_passed_with_parameters.connect(CheckSeasonPassed)

# Information
# Use - Internal
# By - Connected to signal of day passing in time manager
# For - Checks whether the length of a season has passed
# Explanation -
#	If on first day of what would be the next season, advance the internal data
#	Fe [Season Length = 30, day = 31 -> day % length = 1 -> advance season]
# Debug - N/A
func CheckSeasonPassed(day_passed: int) -> void:
	if day_passed % season_length == 1:
		MoveToNextSeason()

# Information
# Use - Internal
# By - CheckSeasonPassed
# For - Changes the value of the current season to the next in order
# Explanation -
#	If not in final season, move onto next season
#	If in final season, move onto first season
# Debug - N/A
func MoveToNextSeason():
	if current_season < len(DataTypes.Seasons.keys()) - 1:
		current_season = DataTypes.Seasons[DataTypes.Seasons.find_key(current_season + 1)]
	elif current_season == len(DataTypes.Seasons.keys()) - 1:
		current_season = DataTypes.Seasons[DataTypes.Seasons.find_key(0)]
