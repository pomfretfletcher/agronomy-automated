class_name TileComponent
extends Node

@export var effected_tilemap_layer: TileMapLayer

@onready var player: Player = get_tree().get_first_node_in_group("player")

var mouse_position: Vector2
var cell_position: Vector2i
var cell_source_id: int
var local_cell_position: Vector2


# Information
# Use - Internal by Child Classes
# By - Child Classes - _unhandled_input
# For - Collects various cell and mouse positions and data for use of components
# Explanation -
#	Uses tilemap layer methods to:
#		Find cell player is currently occupying
#		Find the cell in front of the player
#		Find what tile is placed on that cell (a number index based on tile in 
#			tileset, -1 for empty tile)
#		Find the position of that cell in terms of the world node
#	This information is then used by child classes for different uses
func GetCellInFrontOfPlayer() -> void:
	cell_position = effected_tilemap_layer.local_to_map(player.position)
	cell_position += (Vector2i)(player.player_anim_direction)
	cell_source_id = effected_tilemap_layer.get_cell_source_id(cell_position)
	local_cell_position = effected_tilemap_layer.map_to_local(cell_position)
