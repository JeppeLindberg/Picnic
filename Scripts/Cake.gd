extends Node2D

var _Groups := preload("res://Scripts/Library/Groups.gd").new()

const Nodes := preload("res://Scripts/Nodes.gd")
const GameState := preload("res://Scripts/GameState.gd")
var _ref_Nodes: Nodes
var _ref_GameState: GameState


func _ready():
	add_to_group(_Groups.CAKE)
	_ref_Nodes = get_node("/root/MainScene/Nodes")
	_ref_GameState = get_node("/root/MainScene/GameState")
	_ref_Nodes.add_node(self)

func collide():
	_ref_GameState.lose_health()

