## Component used to allow player to interact with attached building.
## Expects a collision shape 2D attached. This is the area in which the building can be
## interacted from.
## Player can interact through this component as long as they are stood in attached shape.
## Expects building to have both 'interact_with' and 'uninteract_with' functions.
class_name InteractionRangeComponent
extends Area2D

var can_be_interacted_with: bool = false
var currently_interacting: bool = false

@onready var parent_building: Node2D = $".."


# Function Information
# Use - Node Interaction [Likely Building]
# Does - Allows interaction to occur
func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		can_be_interacted_with = true


# Function Information
# Use - Node Interaction [Likely Building]
# Does - Disallows interaction to occur
func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		can_be_interacted_with = false


# Function Information
# Use - Node Interaction [Likely Building]
# Does - Lets player interact with building and calls appropiate methods
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact_with_building"):
		if can_be_interacted_with and not currently_interacting:
			parent_building.call("InteractWith")
			currently_interacting = true
		
		elif currently_interacting:
			parent_building.call("UninteractWith")
			currently_interacting = false
