extends NodeState

@export var player: Player
@export var animated_sprite_2d: AnimatedSprite2D

func _on_physics_process(_delta : float) -> void:
	# Decide animation based on current direction
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
	# Read player input
	GameInputEvents.GetMoveDirection()
	
	# If moving, change to walk
	if GameInputEvents.IsPlayerMoving():
		transition.emit("Walk")

func _on_exit() -> void:
	# Stop animation upon changing state
	animated_sprite_2d.stop()
