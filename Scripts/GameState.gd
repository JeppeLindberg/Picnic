extends Node2D

var _health_display: = []
var _money_display: Label

var current_health = 5
var money = 50

# Not sure it actually has a use as export, but I'm thinking it could be for pre-occopied positions
export (Dictionary) var used_positions
export (int) var start_index
export (int) var end_index
export (int) var lanes
export (int) var grid_size = 64

func create_astar(dict):
	var astar = AStar2D.new()
	var goal_point = 0
	# Goal point is free to travel to
	astar.add_point(goal_point, Vector2(1000, 0), 1)
	
	# Map to next point in line over a lane, for easier connection
	var previous_point = {}
	
	for x in range(start_index, end_index + grid_size, grid_size):
		for yindex in range(lanes):
			var y = yindex *  grid_size
			var pos = Vector2(x, y)
			var point = astar.get_available_point_id()
			if ! dict.has(pos):
				astar.add_point(point, pos, 1) # Future, weight cost should increase slightly to convince ants to change lane as late as possible
				if previous_point.get(yindex) != null:
					
					astar.connect_points(point, previous_point[yindex])
					print("Connecting " + str(previous_point[yindex]) + ", " + str(point))
				
				previous_point[yindex] = point
			else:
				previous_point.erase(yindex)
	
	for p in previous_point.values():
		astar.connect_points(p, goal_point)
	
	return astar

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
	create_astar(used_positions)
