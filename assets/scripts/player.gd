class_name Player
extends CharacterBody2D

var player_anim_direction: Vector2
var player_move_direction: Vector2

@export var current_tool: DataTypes.Tools = DataTypes.Tools.None

func _ready() -> void:
	ToolManager.tool_selected.connect(ToolSelected)
	
func ToolSelected(tool: DataTypes.Tools) -> void:
	current_tool = tool
	print("Current Tool:", tool)
