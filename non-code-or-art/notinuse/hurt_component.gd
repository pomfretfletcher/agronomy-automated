class_name HurtComponent
extends Area2D

@export var equipment : DataTypes.Equipments = DataTypes.Equipments.NONE

signal hurt


func _on_area_entered(area: Area2D) -> void:
	if area is HitComponent:
		var hit_component = area as HitComponent
		
		# If correct equipment for this hurt component, take the damage and call on hurt
		if equipment == hit_component.current_equipment:
			hurt.emit(hit_component.hit_damage)
