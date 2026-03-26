class_name InWorldStorageInterface
extends StorageInterface

@export var using_crate: Crate

func _ready() -> void:
	slot_framework = ReusedPackedSceneDictionary.packed_scene_dictionary["storage_slot_framework"]
	row_framework = ReusedPackedSceneDictionary.packed_scene_dictionary["storage_row_framework"]
	call_deferred("SetupInterface")
