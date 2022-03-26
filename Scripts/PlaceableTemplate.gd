extends Node

export (PackedScene) var spawn_object
export (PackedScene) var preview_object
export (int) var snap_pixels = 64

func get_spawn_object():
	return spawn_object
	
func get_preview_object():
	return preview_object

func position_filter(position : Vector2):
	return Vector2(round(position.x/snap_pixels) * snap_pixels, round(position.y / snap_pixels) * snap_pixels)

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
