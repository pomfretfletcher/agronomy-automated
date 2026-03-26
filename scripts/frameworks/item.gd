class_name Item
extends Node2D

var item_name: String

func ChangeItemName(new_name: String) -> void:
	item_name = new_name
	
func ChangeItemSprite(sprite: Texture2D) -> void:
	var sprite_2d: Sprite2D = $Sprite2D
	sprite_2d.texture = sprite

func OnPickup(_body: Node2D) -> void:
	InventoryManager.AddItemToInventory(item_name, 1)
	queue_free()
