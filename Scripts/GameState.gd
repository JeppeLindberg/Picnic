extends Node2D

var _health1: TextureRect
var _health2: TextureRect
var _health3: TextureRect


func lose_health():
	pass

func _ready():
	_health1 = get_node("/root/MainScene/GUI/HealthContainer/Health1")
	_health2 = get_node("/root/MainScene/GUI/HealthContainer/Health2")
	_health3 = get_node("/root/MainScene/GUI/HealthContainer/Health3")
