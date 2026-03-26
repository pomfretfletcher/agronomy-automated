class_name Player
extends CharacterBody2D

@export var hit_component_collision_shape: CollisionShape2D

var player_anim_direction: Vector2
var player_move_direction: Vector2

var can_move: bool = true
var can_use_tools: bool = true
var can_plant: bool = true
var can_build: bool = true

@export var current_tool: DataTypes.Tools = DataTypes.Tools.None
var current_seed: DataTypes.Seeds = DataTypes.Seeds.None

func _ready() -> void:
	ToolManager.tool_selected.connect(ToolSelected)
	ToolManager.seed_selected.connect(SeedSelected)

	# Hit component for tools does not need to be active at game start
	hit_component_collision_shape.disabled = true
	hit_component_collision_shape.position = Vector2.ZERO
	
func ToolSelected(tool: DataTypes.Tools) -> void:
	current_tool = tool
	
func SeedSelected(new_seed: DataTypes.Seeds) -> void:
	current_seed = new_seed

func RemoveControl() -> void:
	can_move = false
	can_use_tools = false
	can_plant = false
	can_build = false
	
func ReturnControl() -> void:
	can_move = true
	can_use_tools = true
	can_plant = true
	can_build = true
