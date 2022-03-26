extends Node2D

var _Groups := preload("res://Scripts/Library/Groups.gd").new()

var _ref_GameState: Node2D

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
	if node.is_in_group(_Groups.ENEMY):
		if get_all_nodes_in_group(_Groups.ENEMY).size() == 0:
			_ref_GameState.end_wave()

func _ready():
	_ref_GameState = get_node("/root/MainScene/GameState")

