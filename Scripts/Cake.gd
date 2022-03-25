extends Node2D

var _Groups := preload("res://Scripts/Library/Groups.gd").new()

const Nodes := preload("res://Scripts/Nodes.gd")
var _ref_Nodes: Nodes


func _ready():
	add_to_group(_Groups.CAKE)
	_ref_Nodes = get_node("/root/MainScene/Nodes")
	_ref_Nodes.add_node(self)

