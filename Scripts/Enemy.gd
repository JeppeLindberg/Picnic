extends KinematicBody2D

var _StageCoords := preload("res://Scripts/Library/StageCoords.gd").new()
var _Groups := preload("res://Scripts/Library/Groups.gd").new()

var start_pos: Vector2
var target_pos: Vector2
var speed: float

const Nodes := preload("res://Scripts/Nodes.gd")
var _ref_Nodes: Nodes


func _ready():
	add_to_group(_Groups.ENEMY)
	_ref_Nodes = get_node("/root/MainScene/Nodes")
	_ref_Nodes.add_node(self)
	
	start_pos = position
	speed = 20
	target_pos = Vector2(200,200)
	rotation = (target_pos - start_pos).normalized().rotated(PI / 2).angle()


func _physics_process(delta):
	var movement_vec: Vector2
	movement_vec = (target_pos - start_pos).normalized() * delta * speed
	move_and_collide(movement_vec)

func collide():
	_ref_Nodes.remove_from_nodes(self)
	self.queue_free()
