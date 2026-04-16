class_name ItemPickup
extends Node2D

var item_name: String
@export var sprite_2d: Sprite2D


# Function Information
# Use - Item Dropping
# Does - Sets name of item equal to the given name
func ChangeItemName(given_name: String) -> void:
	item_name = given_name


# Function Information
# Use - Item Dropping
# Does - Sets sprite of item equal to the given sprite
func ChangeItemSprite(given_sprite: Texture2D) -> void:
	sprite_2d.texture = given_sprite


# Function Information
# Use - Item Pickup
# Does - Adds picked up item to player inventory, then deletes self
func OnPickup(body: Node2D) -> void:
	if body is Player:
		InventoryManager.AddItemToInventory(item_name, 1)
		queue_free()
