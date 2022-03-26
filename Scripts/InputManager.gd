extends Node2D

class Test:
	var stuff = 2


export (PackedScene) var spawn
export (Array, NodePath) var objects

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

func destroy_preview_object():
	if previewObject:
		previewObject.queue_free()
		previewObject = null
		
func get_or_create_preview():
	if !previewObject:
		previewObject = activeButton.get_preview_object().instance()
		get_owner().add_child(previewObject)
	return previewObject

func _input(event):
	if event is InputEventMouseMotion:
		var newButton = query_buttons(event.position)
		if newButton != hoverButton: 
			print("Changing active button from {from} to {to}".format({"from": activeButton, "to": newButton}))
			destroy_preview_object()
			hoverButton = newButton
		elif !newButton and activeButton:
			var obj = get_or_create_preview()
			obj.position = event.position
	
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
		elif activeButton:
			destroy_preview_object()
			var enemy = activeButton.get_spawn_object().instance()
			get_owner().add_child(enemy)
			enemy.position = event.position
			activeButton = null

# Declare member variables here. Examples:
# var a = 2
# var b = "text"




# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
