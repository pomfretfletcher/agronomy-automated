extends Node

var starting_season: DataTypes.Seasons = DataTypes.Seasons.SPRING
var current_season: DataTypes.Seasons
var season_length: int = 30


# Function Information
# Use - Seasons
# Does - Sets initial season, connects signal
func _ready() -> void:
	current_season = starting_season
	TimeManager.day_passed_with_parameters.connect(CheckSeasonPassed)


# Function Information
# Use - Seasons
# Does - Check if a whole season has passed. If so, move to next
func CheckSeasonPassed(day_passed: int) -> void:
	if day_passed % season_length == 1:
		MoveToNextSeason()


# Function Information
# Use - Seasons
# Does - Move to next season in order (either next in enum, or first in enum)
func MoveToNextSeason():
	if current_season < len(DataTypes.Seasons.keys()) - 1:
		current_season = DataTypes.Seasons[DataTypes.Seasons.find_key(current_season + 1)]
	elif current_season == len(DataTypes.Seasons.keys()) - 1:
		current_season = DataTypes.Seasons[DataTypes.Seasons.find_key(0)]


func GetSaveData() -> Dictionary:
	var save_data = {
		"current_season": current_season
	}
	return save_data


func ApplyLoadedData(loaded_save_data: Dictionary) -> void:
	var applied = ["current_season"]	
	SaveLoadManager.CheckLoadedDataIsValid(applied, loaded_save_data.keys(), self)

	if loaded_save_data.has("current_season"): current_season = loaded_save_data["current_season"]
