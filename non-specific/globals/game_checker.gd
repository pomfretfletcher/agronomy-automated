extends Node

var not_saveable: bool = true

func _ready() -> void:
	var node_list: Array[Node]
	gdExtensions.AccessAllChildrenRecursive(get_tree().current_scene, node_list)
	CheckStablility(node_list)
	
	get_tree().node_added.connect(CheckNewNode)

func CheckNewNode(new_node: Node) -> void:
	var node_list: Array[Node]
	gdExtensions.AccessAllChildrenRecursive(new_node, node_list)
	call_deferred("CheckStablility", node_list)

func CheckStablility(node_list: Array[Node]) -> void:
	for node in node_list:
		gdExtensions.CheckExportVariablesAssigned(node)
		gdExtensions.CheckPackedScenes(node)
