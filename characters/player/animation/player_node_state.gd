class_name PlayerNodeState
extends NodeState

@export var player: Player
@export var animated_sprite_2d: AnimatedSprite2D
@export var hit_component: HitComponent

func CheckToolTransitions() -> void:
	if GameInputEvents.IsUsingTool() and player.can_use_tools:
		hit_component.current_tool = ToolManager.selected_tool
		if ToolManager.selected_tool == DataTypes.Tools.Hoe:
			transition.emit("Tilling")
			
		if ToolManager.selected_tool == DataTypes.Tools.WateringCan:
			transition.emit("Watering")
