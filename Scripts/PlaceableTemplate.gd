extends Node

#Script for a button with its state

export (PackedScene) var spawn_object
export (PackedScene) var preview_object

func get_spawn_object():
	return spawn_object
	
func get_preview_object():
	return preview_object

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
