class_name OpenCloseInteractionRangeComponent
extends InteractionRangeComponent

@onready var using_node: Node2D = $".."

var can_be_interacted_with: bool = false
var currently_interacting: bool = false

# Function Information
# Use - Node Interaction [Likely Building]
# Does - Allows interaction to occur
# Debug - N/A
func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		can_be_interacted_with = true

# Function Information
# Use - Node Interaction [Likely Building]
# Does - Disallows interaction to occur
# Debug - N/A
func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		can_be_interacted_with = false

# Function Information
# Use - Node Interaction [Likely Building]
# Does - Lets player interact with building and calls appropiate methods
# Debug - N/A
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		if can_be_interacted_with and not currently_interacting:
			InteractWith()
			currently_interacting = true
		
		elif currently_interacting:
			UninteractWith()
			currently_interacting = false

# Function Information
# Use - Node Interaction [Likely Building]
# Does - Calls appropiate method in node component is attached to
# Debug - N/A
func InteractWith() -> void:
	using_node.call("interact_with")

# Function Information
# Use - Node Interaction [Likely Building]
# Does - Calls appropiate method in node component is attached to
# Debug - N/A
func UninteractWith() -> void:
	using_node.call("uninteract_with")
