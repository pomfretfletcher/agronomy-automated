extends NodeState

@export var player: Player
@export var animated_sprite_2d: AnimatedSprite2D

func _on_next_transitions() -> void:
	if !animated_sprite_2d.is_playing():
		transition.emit("Idle")

func _on_enter() -> void:
	if player.player_anim_direction == Vector2.LEFT:
		animated_sprite_2d.play("watering_left")
	elif player.player_anim_direction == Vector2.RIGHT:
		animated_sprite_2d.play("watering_right")
	elif player.player_anim_direction == Vector2.UP:
		animated_sprite_2d.play("watering_back")
	elif player.player_anim_direction == Vector2.DOWN:
		animated_sprite_2d.play("watering_front")
