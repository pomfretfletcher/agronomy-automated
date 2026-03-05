extends NodeState

@export var player: Player
@export var animated_sprite_2d: AnimatedSprite2D
@export var speed: int = 50

func _on_physics_process(_delta : float) -> void:
	# Read player input
	var anim_direction: Vector2 = GameInputEvents.GetAnimDirection()
	var move_direction: Vector2 = GameInputEvents.GetMoveDirection()
	
	# Decide animation based on input
	if anim_direction == Vector2.LEFT:
		animated_sprite_2d.play("walk_left")
	elif anim_direction == Vector2.RIGHT:
		animated_sprite_2d.play("walk_right")
	elif anim_direction == Vector2.UP:
		animated_sprite_2d.play("walk_back")
	elif anim_direction == Vector2.DOWN:
		animated_sprite_2d.play("walk_front")

	# Store player's direction - keep orientation on changing states
	if move_direction != Vector2.ZERO:
		player.player_anim_direction = anim_direction
		player.player_move_direction = move_direction
	
	# Apply velocity / movement
	player.velocity = move_direction * speed
	player.move_and_slide()

func _on_next_transitions() -> void:
	# Read player input
	GameInputEvents.GetMoveDirection()
	
	# If not moving, change back to idle
	if !GameInputEvents.IsPlayerMoving():
		transition.emit("Idle")

func _on_exit() -> void:
	# Stop animation upon changing state
	animated_sprite_2d.stop()
