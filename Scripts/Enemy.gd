extends KinematicBody2D

var _StageCoords := preload("res://Scripts/Library/StageCoords.gd").new()
var _Groups := preload("res://Scripts/Library/Groups.gd").new()

var initialized = false
var start_pos: Vector2
var target_pos: Vector2
export var speed: float

const Nodes := preload("res://Scripts/Nodes.gd")
var _ref_Nodes: Nodes


func _ready():
	add_to_group(_Groups.ENEMY)
	_ref_Nodes = get_node("/root/MainScene/Nodes")
	_ref_Nodes.add_node(self)
	
func _process(delta):
	if not initialized:
		var cake_nodes = _ref_Nodes.get_all_nodes_in_group(_Groups.CAKE)
		if cake_nodes.size() > 0:
			target_pos = cake_nodes[0].position
			initialized = true

func _physics_process(delta):
	var movement_vec = (target_pos - position).normalized() * delta * speed
	rotation = movement_vec.normalized().rotated(PI / 2).angle()
	var collision = move_and_collide(movement_vec)
	if collision:
		collision.collider.collide()
		collide()

func collide():
	_ref_Nodes.remove_from_nodes(self)
	self.queue_free()
