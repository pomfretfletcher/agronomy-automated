extends PlayerNodeState


func _on_physics_process(_delta : float) -> void:
	if !player.can_move:
		return
		
	# Read player input based on movement
	var anim_direction: Vector2 = GameInputEvents.GetAnimDirection()
	var move_direction: Vector2 = GameInputEvents.GetMoveDirection()
	
	# Decide animation based on player directions
	if anim_direction == Vector2.LEFT:
		animated_sprite_2d.play("walk_left")
	elif anim_direction == Vector2.RIGHT:
		animated_sprite_2d.play("walk_right")
	elif anim_direction == Vector2.UP:
		animated_sprite_2d.play("walk_back")
	elif anim_direction == Vector2.DOWN:
		animated_sprite_2d.play("walk_front")
	else:
		print("Error deciding player animation.")
		return
		
	if move_direction != Vector2.ZERO:
		# Store player's direction - keep orientation on changing states
		player.player_anim_direction = anim_direction
		player.player_move_direction = move_direction
	
		# Apply velocity / movement
		player.velocity = move_direction * DecideMoveSpeed()
		player.move_and_slide()


func _on_next_transitions() -> void:
	GameInputEvents.GetMoveDirection()
	
	if (!GameInputEvents.IsPlayerMoving() or !player.can_move) and !GameInputEvents.IsUsingEquipment():
		transition.emit("Idle")
	
	CheckEquipmentTransitions()


func _on_exit() -> void:
	animated_sprite_2d.stop()


func DecideMoveSpeed() -> float:
	# Default return value
	var return_speed = player.regular_move_speed
	
	for tilemap in player.slow_move_tilemap_layers:
		# Find player current position on tilemap and what tile is below them on that map
		var cell_position = tilemap.local_to_map(player.position)
		var cell_source_id = tilemap.get_cell_source_id(cell_position)
		
		# If there is a tile on the cell, set return speed to the slow move speed
		if cell_source_id != -1:
			return_speed = player.slow_move_speed
		
	return return_speed
