class_name Crate
extends Node2D

@export var inworld_storage_interface: InWorldStorageInterface
@onready var storage_interface_interaction_component: StorageInterfaceInteractionComponent = get_tree().get_first_node_in_group("storageinterfaceinteractioncomponent")

func _ready() -> void:
	inworld_storage_interface.hide()
	
func interact_with() -> void:
	# open
	storage_interface_interaction_component.OpenInterfaces(inworld_storage_interface)
	
func uninteract_with() -> void:
	# close
	storage_interface_interaction_component.CloseInterfaces()
