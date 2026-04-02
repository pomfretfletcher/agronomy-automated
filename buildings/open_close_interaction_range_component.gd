class_name OpenCloseInteractionRangeComponent
extends InteractionRangeComponent

@export var using_node: Node2D

var can_be_interacted_with: bool = false
var currently_interacting: bool = false

@warning_ignore("unused_parameter")
func _on_body_entered(body: Node2D) -> void:
	can_be_interacted_with = true

@warning_ignore("unused_parameter")
func _on_body_exited(body: Node2D) -> void:
	can_be_interacted_with = false
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		if can_be_interacted_with and not currently_interacting:
			InteractWith()
			currently_interacting = true
		
		elif currently_interacting:
			UninteractWith()
			currently_interacting = false

func InteractWith() -> void:
	using_node.call("interact_with")
	
func UninteractWith() -> void:
	using_node.call("uninteract_with")
