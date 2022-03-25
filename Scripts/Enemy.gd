extends Node2D

var _StageCoords := preload("res://Scripts/Library/StageCoords.gd").new()

var start_pos: Vector2
var target_pos: Vector2
var speed: float


func _ready():
	start_pos = position
	speed = 20
	target_pos = Vector2(200,200)
	rotation = (target_pos - start_pos).normalized().rotated(PI / 2).angle()


func _process(delta):
	var movement_vec: Vector2
	movement_vec = (target_pos - start_pos).normalized() * delta * speed
	position += movement_vec
