class_name Item
extends Node2D

var item_name: String

func ChangeItemName(name: String) -> void:
	item_name = name
	
func ChangeItemSprite(sprite: AtlasTexture) -> void:
	var sprite_2d: Sprite2D = $Sprite2D
	sprite_2d.texture = sprite

func _on_area_entered(area: Area2D) -> void:
	print("AREA ENTERED")
	InventoryManager.AddItemToInventory(item_name, 1)
	queue_free()
