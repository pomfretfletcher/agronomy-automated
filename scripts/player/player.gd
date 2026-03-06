class_name Player
extends CharacterBody2D

@onready var hit_component_collision_shape: CollisionShape2D = $HitComponent/CollisionShape2D

var player_anim_direction: Vector2
var player_move_direction: Vector2

@export var current_tool: DataTypes.Tools = DataTypes.Tools.None

func _ready() -> void:
	ToolManager.tool_selected.connect(ToolSelected)

	# Hit component for tools does not need to be active at game start
	hit_component_collision_shape.disabled = true
	hit_component_collision_shape.position = Vector2.ZERO
	
func ToolSelected(tool: DataTypes.Tools) -> void:
	current_tool = tool
