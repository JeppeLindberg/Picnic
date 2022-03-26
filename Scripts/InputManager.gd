extends Node2D

class Test:
	var stuff = 2

var _Groups := preload("res://Scripts/Library/Groups.gd").new()

const GameState := preload("res://Scripts/GameState.gd")
var _ref_GameState: GameState

export (NodePath) var marker
export (Array, NodePath) var objects
export (Color) var normal_color = Color.white
export (Color) var invalid_color = Color.red


func _ready():
	_ref_GameState = get_node("/root/MainScene/GameState")	
	
func query_buttons(position):
	for obj in objects:
		var node = get_node(obj)
		var texture = node.texture
		var size = texture.get_size() / 2
		var dist  = (node.position - position).abs()
		if size.x > dist.x and size.y > dist.y and node.visible:
			return node
	return null

# HoverButton is the button the mouse is currently over
var hoverButton = null
# ActiveButton is the button last clicked on
var activeButton = null
# An object preview of what activeButton is
var previewObject = null

func destroy_preview_object():
	if previewObject:
		previewObject.queue_free()
		previewObject = null
		
func get_or_create_preview():
	if !previewObject:
		previewObject = activeButton.get_preview_object().instance()
		get_owner().add_child(previewObject)
	return previewObject
	
func _physics_process(delta):
	var space = get_world_2d().direct_space_state
	var mousePos = get_global_mouse_position()
	var intersect = space.intersect_point(mousePos, 1)
	if intersect:
		for i in intersect:
			if i.collider.is_in_group(_Groups.PICKUP):
				i.collider.hover_mouse()

func _input(event):
	var rounded_position = Vector2(-1000, -1000)
	var can_place = false
	if activeButton and "position" in event: #EventKey
		rounded_position = activeButton.position_filter(event.position)
		#price check
		can_place =  _ref_GameState.current_money >= activeButton.price
		
		
		#astar prep
		var expandedPositions = _ref_GameState.used_positions.duplicate()
		
		var all_postions = []
		for pos in activeButton.extraPositions:
			var realPos = pos + rounded_position
			#Collision
			can_place = can_place and not _ref_GameState.used_positions.has(realPos)
			#Astar
			expandedPositions[realPos] = true
		
		#Astar finish
		#Check if placing would prevent pathfind
		var newastar = _ref_GameState.create_astar(expandedPositions)
		var route = newastar.get_point_path(1, 0)
		can_place = can_place and (! route.empty())
		
		
		if previewObject:
			previewObject.modulate = normal_color if can_place else invalid_color 
		
	if event is InputEventMouseMotion:
		var newButton = query_buttons(event.position)
		if newButton != hoverButton: 
			print("Changing active button from {from} to {to}".format({"from": activeButton, "to": newButton}))
			destroy_preview_object()
			hoverButton = newButton
		elif !newButton and activeButton:
			var obj = get_or_create_preview()
			obj.position = rounded_position
	
	
	elif event is InputEventMouseButton and event.pressed:
		#Is mouse over a button
		if hoverButton != null:
			print("click() on sprite")
			destroy_preview_object()
			if activeButton == hoverButton:
				activeButton = null
			else:
				activeButton = hoverButton
		#Or a button has been clicked
		elif activeButton  and can_place:
			var tower = activeButton.get_spawn_object().instance()
			get_owner().add_child(tower)
			tower.position = rounded_position
			_ref_GameState.lose_money(activeButton.price)
			destroy_preview_object()
			for pos in activeButton.extraPositions:
				var realPos = pos + rounded_position
				_ref_GameState.used_positions[realPos] = true
			_ref_GameState.reset_pathfinding()
			
			activeButton.limit -= 1
			if activeButton.limit == 0:
				activeButton.visible = false
			
			activeButton = null
