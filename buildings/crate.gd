class_name Crate
extends Node2D

@export var storage_interface: StorageInterface
@onready var storage_inventory_interaction_component: StorageInventoryInteractionComponent = get_tree().get_first_node_in_group("storageinventoryinteractioncomponent")

# Information
# Use - Internal
# By - Game Startup
# For - Hides visual interface
# Explanation -
#	Hides visual interface
# Debug - N/A
func _ready() -> void:
	storage_interface.hide()
	
func interact_with() -> void:
	storage_inventory_interaction_component.OpenInterfaces(storage_interface)
	
func uninteract_with() -> void:
	storage_inventory_interaction_component.CloseInterfaces()
