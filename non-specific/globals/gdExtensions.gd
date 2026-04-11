class_name gdExtensions
extends Node

var not_saveable: bool = true

static func GetParentByType(parent_type: String, searching_node: Node) -> Node:
	var parent = searching_node.get_parent()
	if parent != null:
		if parent.get_script() and String(parent.get_script().get_global_name()) == parent_type:
			return parent
		else:
			return GetParentByType(parent_type, parent)
	return null

static func GetImmediateChildOfType(child_type: String, searching_node: Node) -> Node:
	for child in searching_node.get_children():
		if child.get_script() and String(child.get_script().get_global_name()) == child_type:
			return child
	return null

static func StringArrayToVector2iArray(given_array: Array) -> Array[Vector2i]:
	var result: Array[Vector2i]
	for vector in given_array:
		vector = vector.replace("(", "").replace(")", "")
		var parts = vector.split(",")
		var to_append: Vector2i = Vector2i(int(parts[0]), int(parts[1]))
		result.append(to_append)
	return result

static func ClearTileMapLayer(tilemap_layer: TileMapLayer) -> void:
	tilemap_layer.set_cells_terrain_connect(tilemap_layer.get_used_cells(), 0, -1, true)

static func CheckExportVariablesAssigned(node: Node) -> void:
	if node.get_script() == null:
		return
		
	for variable in node.get_property_list():
		var usage = variable.usage
		
		if (usage & PROPERTY_USAGE_SCRIPT_VARIABLE) and (usage & PROPERTY_USAGE_EDITOR):
			# skip optional exports
			if variable.name in Constants.IGNORE_EXPORT_CHECK:
				continue
				
			var value = node.get(variable.name)
			if value == null:
				print("Not all export variables on " + str(node) + " assigned correctly.")
				print("Variable " + str(variable) + " not properly assigned.")
				return

static func CheckPackedScenes(node: Node) -> void:
	if node.get_script() == null:
		return
		
	for variable in node.get_property_list():
		var value = node.get(variable.name)
		if value is PackedScene and !value.can_instantiate():
			print("Packed scene " + str(variable) + " cannot instantiate.")
				
static func AccessAllChildrenRecursive(node: Node, node_list: Array[Node]) -> void:
	node_list.append(node)
	for child in node.get_children():
		if child is Node:
			AccessAllChildrenRecursive(child, node_list)

static func IsArray2D(array: Array) -> bool:
	if array[0] is Array:
		return true
	return false

static func IsArray1D(array: Array) -> bool:
	if array[0] is Array:
		return false
	return true

static func GetChildByName(parent: Node, child_name: String) -> Node:
	var result: Node
	result = parent.find_child(child_name)
	if result != null:
		return result
	print("Error getting child of name " + child_name + " connected to parent " + str(parent) + ". No child node of the given name present.")
	return null
