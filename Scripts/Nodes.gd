extends Node2D

var _nodes = []


func add_node(node):
	_nodes.append(node)


func get_all_nodes_in_group(group):
	var result = []
	for n in _nodes:
		if n.is_in_group(group):
			result.append(n)
	return result
	
func remove_from_nodes(node):
	_nodes.erase(node)


func _ready():
	pass

