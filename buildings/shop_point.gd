class_name SellPoint
extends Node2D

@export var shop_interface: ShopInterface
@onready var sell_point_interaction_component: SellPointInventoryInteractionComponent = get_tree().get_first_node_in_group("sellpointinventoryinteractioncomponent")

func interact_with() -> void:
	sell_point_interaction_component.OpenInterfaces(shop_interface)
	
func uninteract_with() -> void:
	sell_point_interaction_component.CloseInterfaces()
