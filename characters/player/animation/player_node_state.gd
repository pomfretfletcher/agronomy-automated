class_name PlayerNodeState
extends NodeState

@export var player: Player
@export var animated_sprite_2d: AnimatedSprite2D
@export var hit_component: HitComponent

func CheckEquipmentTransitions() -> void:
	if GameInputEvents.IsUsingEquipment() and player.can_use_equipment:
		if ToolManager.selected_equipment == DataTypes.Equipments.HOE:
			transition.emit("Tilling")
			
		if ToolManager.selected_equipment == DataTypes.Equipments.WATERING_CAN:
			transition.emit("Watering")
