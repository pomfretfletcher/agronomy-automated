class_name MouseComponent
extends Node2D

@export var clickable_tilemap_layer: TileMapLayer
@export var mouse_reach: float = 30.0

@onready var player: Player = get_tree().get_first_node_in_group("player")

var mouse_position: Vector2
var cell_position: Vector2i
var cell_source_id: int
var local_cell_position: Vector2
var distance: float

func GetTargetedCell() -> void:
	mouse_position = clickable_tilemap_layer.get_local_mouse_position()
	cell_position = clickable_tilemap_layer.local_to_map(mouse_position)
	cell_source_id = clickable_tilemap_layer.get_cell_source_id(cell_position)
	local_cell_position = clickable_tilemap_layer.map_to_local(cell_position)
	distance = player.global_position.distance_to(local_cell_position)
