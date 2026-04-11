class_name StorageBuilding
extends Building

func _ready() -> void:
	inventory_interaction_component = get_tree().get_first_node_in_group("storageinventoryinteractioncomponent")
