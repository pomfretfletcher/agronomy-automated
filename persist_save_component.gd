class_name PersistSaveComponent
extends SaveDataComponent


func _ready() -> void:
	super()
	parent_node.add_to_group("persisting_node")
