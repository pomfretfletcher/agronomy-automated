extends Node

var not_saveable: bool = true

@export var database: Dictionary[String, Data]
@export var backup_dictionary: Dictionary[String, Data]

func GetCropScene(given_seed: DataTypes.Seeds) -> PackedScene:
	for entry in database.values():
		if entry is CropData:
			if entry.seed_enum == given_seed:
				return entry.crop_scene
	return null
