extends Node2D

@export var player: Player
@export var tilemap_layer: TileMapLayer
var cell_position: Vector2i

# Information
# Use - Internal
# By - Game Startup
# For - Shows overlay
# Explanation -
#	Shows overlay (allows to be hidden during editor)
# Debug - N/A
func _ready() -> void:
	visible = true

@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	cell_position = tilemap_layer.local_to_map(player.position)
	
	# Place selected tile overlay on the tile the player is looking at
	# /effecting
	if player.player_anim_direction == Vector2.UP:
		position = (cell_position+ Vector2i(0, -1)) * GlobalData.pixel_size
	elif player.player_anim_direction == Vector2.DOWN:
		position = (cell_position+ Vector2i(0, 1)) * GlobalData.pixel_size
	elif player.player_anim_direction == Vector2.LEFT:
		position = (cell_position+ Vector2i(-1, 0)) * GlobalData.pixel_size
	elif player.player_anim_direction == Vector2.RIGHT:
		position = (cell_position+ Vector2i(1, 0)) * GlobalData.pixel_size
	else:
		position = cell_position * GlobalData.pixel_size
