class_name Player
extends CharacterBody2D

@export var hit_component_collision_shape: CollisionShape2D

var player_anim_direction: Vector2
var player_move_direction: Vector2

var can_move: bool = true
var can_use_equipment: bool = true
var can_plant: bool = true
var can_build: bool = true
var has_control: bool = true

var internal_name: String = "player"

# Function Information
# Use - Control Hit Component
# Does - Sets up hit component in appropiate state
# Debug - N/A
func _ready() -> void:
	hit_component_collision_shape.disabled = true

# Function Information
# Use - Player Control
# Does - Set all internal state variables to not allow player to execute certain interactions
# Debug - N/A
func RemoveControl() -> void:
	can_move = false
	can_use_equipment = false
	can_plant = false
	can_build = false
	has_control = false

# Function Information
# Use - Player Control
# Does - Set all internal state variables to allow player to execute certain interactions
# Debug - N/A
func ReturnControl() -> void:
	can_move = true
	can_use_equipment = true
	can_plant = true
	can_build = true
	has_control = true

func GetSaveData() -> Dictionary:
	var save_data = {
		"has_control": has_control,
		"global_position_x": global_position.x,
		"global_position_y": global_position.y,
		"internal_name": internal_name
	}
	return save_data

func ApplyLoadedData(loaded_save_data: Dictionary) -> void:
	var applied = ["has_control", "global_position_x", "global_position_y"]	
	SaveLoadManager.CheckLoadedDataIsValid(applied, loaded_save_data.keys(), self)
	if loaded_save_data.has("has_control"): 
		if loaded_save_data["has_control"] == true:
			ReturnControl()
		else:
			RemoveControl()
	if loaded_save_data.has("global_position_x"): 
		global_position = Vector2(loaded_save_data["global_position_x"], loaded_save_data["global_position_y"])
