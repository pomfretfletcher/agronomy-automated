class_name GameInputEvents

static var anim_direction: Vector2
static var move_direction: Vector2

static var up_flag: float = 0.0
static var down_flag: float = 0.0
static var left_flag: float = 0.0
static var right_flag: float = 0.0

static func GetMoveDirection() -> Vector2:
	up_flag = 1.0 if Input.is_action_pressed("walk_up") else 0.0
	down_flag = 1.0 if Input.is_action_pressed("walk_down") else 0.0
	left_flag = 1.0 if Input.is_action_pressed("walk_left") else 0.0
	right_flag = 1.0 if Input.is_action_pressed("walk_right") else 0.0
	move_direction = Vector2(right_flag - left_flag, down_flag - up_flag)
	
	return move_direction.normalized()
	
static func GetAnimDirection() -> Vector2:
	if Input.is_action_pressed("walk_up"):
		anim_direction = Vector2.UP
	elif Input.is_action_pressed("walk_down"):
		anim_direction = Vector2.DOWN
	elif Input.is_action_pressed("walk_left"):
		anim_direction = Vector2.LEFT
	elif Input.is_action_pressed("walk_right"):
		anim_direction = Vector2.RIGHT
	else:
		anim_direction = Vector2.ZERO
		
	return anim_direction
	
static func IsPlayerMoving() -> bool:
	if move_direction == Vector2.ZERO:
		return false
	else:
		return true
