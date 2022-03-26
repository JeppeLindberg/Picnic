extends Node2D

var _health_display: = []
var _money_display: Label

var current_health = 5
var money = 50


func lose_money(subtraction):
	money -= subtraction
	
	update_display()

func lose_health():
	current_health -= 1
	
	if current_health == 0:
		print("Game over")
	
	update_display()

func update_display():	
	for node in _health_display:
		node.visible = false
	for i in range(0,current_health):
		_health_display[i].visible = true
	_money_display.text = " x " + String(money)

func _ready():
	_health_display.append(get_node("/root/MainScene/GUI/RightBottom/HealthContainer/Health1"))
	_health_display.append(get_node("/root/MainScene/GUI/RightBottom/HealthContainer/Health2"))
	_health_display.append(get_node("/root/MainScene/GUI/RightBottom/HealthContainer/Health3"))
	_health_display.append(get_node("/root/MainScene/GUI/RightBottom/HealthContainer/Health4"))
	_health_display.append(get_node("/root/MainScene/GUI/RightBottom/HealthContainer/Health5"))
	_health_display.append(get_node("/root/MainScene/GUI/RightBottom/HealthContainer/Health6"))
	_money_display = get_node("/root/MainScene/GUI/RightBottom/MoneyContainer/Label")
	
	update_display()
