class_name HurtComponent
extends Area2D

@export var tool : DataTypes.Tools = DataTypes.Tools.None

signal hurt

func _on_area_entered(area: Area2D) -> void:
	if area is HitComponent:
		var hit_component = area as HitComponent
		
		# If correct tool for this hurt component, take the damage and call on hurt
		if tool == hit_component.current_tool:
			hurt.emit(hit_component.hit_damage)
