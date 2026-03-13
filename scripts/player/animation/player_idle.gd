extends NodeState

@export var player: Player
@export var animated_sprite_2d: AnimatedSprite2D
@onready var hit_component: HitComponent = $"../../HitComponent"

func _on_physics_process(_delta : float) -> void:
	if player.player_anim_direction == Vector2.LEFT:
		animated_sprite_2d.play("idle_left")
	elif player.player_anim_direction == Vector2.RIGHT:
		animated_sprite_2d.play("idle_right")
	elif player.player_anim_direction == Vector2.UP:
		animated_sprite_2d.play("idle_back")
	elif player.player_anim_direction == Vector2.DOWN:
		animated_sprite_2d.play("idle_front")
	else:
		animated_sprite_2d.play("idle_front")

func _on_next_transitions() -> void:
	GameInputEvents.GetMoveDirection()
	
	if GameInputEvents.IsUsingTool():
		hit_component.current_tool = ToolManager.selected_tool
		if ToolManager.selected_tool == DataTypes.Tools.Hoe:
			transition.emit("Tilling")
			
		if ToolManager.selected_tool == DataTypes.Tools.WateringCan:
			transition.emit("Watering")
			
	if GameInputEvents.IsPlayerMoving():
		transition.emit("Walk")

func _on_exit() -> void:
	animated_sprite_2d.stop()
