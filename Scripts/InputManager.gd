extends Node2D

class Test:
	var stuff = 2

const GameState := preload("res://Scripts/GameState.gd")
var _ref_GameState: GameState

export (PackedScene) var spawn
export (Array, NodePath) var objects

func _ready():
	_ref_GameState = get_node("/root/MainScene/GameState")	
	
func query_buttons(position):
	for obj in objects:
		var node = get_node(obj)
		var texture = node.texture
		var size = texture.get_size()
		var dist  = (node.position - position).abs()
		if size.x > dist.x and size.y > dist.y:
			return node
	return null

# HoverButton is the button the mouse is currently over
var hoverButton = null
# ActiveButton is the button last clicked on
var activeButton = null
# An object preview of what activeButton is
var previewObject = null

func _input(event):
	if event is InputEventMouseMotion:
		var newButton = query_buttons(event.position)
		if newButton != hoverButton: 
			print("Changing active button from {from} to {to}".format({"from": activeButton, "to": newButton}))
			hoverButton = newButton
	
	elif event is InputEventMouseButton and event.pressed:
		#Is mouse over a button
		if hoverButton != null:
			print("click() on sprite")
			if previewObject:
				previewObject.queue_free()
				previewObject = null
			if activeButton == hoverButton:
				activeButton = null
			else:
				activeButton = hoverButton
		#Or a button has been clicked
		elif activeButton:
			var tower = activeButton.get_spawn_object().instance()
			if _ref_GameState.money >= tower.price:
				get_owner().add_child(tower)
				tower.position = event.position
				_ref_GameState.lose_money(tower.price)
			else:
				print("Not enough money")
			activeButton = null
