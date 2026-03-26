class_name gdExtensions
extends Node

static func GetParentByType(parent_type: String, searching_node: Node) -> Node:
	var parent = searching_node.get_parent()
	if parent != null:
		if parent.get_script() and String(parent.get_script().get_global_name()) == parent_type:
			return parent
		else:
			return GetParentByType(parent_type, parent)
	return null
