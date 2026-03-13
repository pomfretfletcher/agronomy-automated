class_name TileComponent
extends Node2D

@export var clickable_tilemap_layer: TileMapLayer

@onready var player: Player = get_tree().get_first_node_in_group("player")

var mouse_position: Vector2
var cell_position: Vector2i
var cell_source_id: int
var local_cell_position: Vector2

func GetCellInFrontOfPlayer() -> void:
	cell_position = clickable_tilemap_layer.local_to_map(player.position)
	cell_position += (Vector2i)(player.player_anim_direction)
	cell_source_id = clickable_tilemap_layer.get_cell_source_id(cell_position)
	local_cell_position = clickable_tilemap_layer.map_to_local(cell_position)
