extends Node2D


@export var player: Player
@export var tilemap_layer: TileMapLayer
var cell_position: Vector2i
var cell_source_id: int
var local_cell_position: Vector2
var distance: float

func _process(delta: float) -> void:
	cell_position = tilemap_layer.local_to_map(player.position)
	if player.player_anim_direction == Vector2.UP:
		position = cell_position * 16 + Vector2i(0, -16)
	elif player.player_anim_direction == Vector2.DOWN:
		position = cell_position * 16 + Vector2i(0, 16)
	elif player.player_anim_direction == Vector2.LEFT:
		position = cell_position * 16 + Vector2i(-16, 0)
	elif player.player_anim_direction == Vector2.RIGHT:
		position = cell_position * 16 + Vector2i(16, 0)
	else:
		position = cell_position * 16
