extends KinematicBody2D

var _StageCoords := preload("res://Scripts/Library/StageCoords.gd").new()
var _Groups := preload("res://Scripts/Library/Groups.gd").new()

var initialized = false
var start_pos: Vector2
var target_pos: Vector2
var dead = false
export var speed: float

const Nodes := preload("res://Scripts/Nodes.gd")
var _ref_Nodes: Nodes

var path : PoolVector2Array

func set_route(points : PoolVector2Array):
	path = points

func pathfind(astar : AStar2D):
	var start_point = astar.get_closest_point(position)
	var route = astar.get_point_path(start_point, 0)
	if route.empty():
		print("Enemy unable to find path. This should never happen")
		route.push_back(target_pos)
	set_route(route)

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
	var distance_to_next_node =  (path[0] - position).length()
	var time_to_next_node = distance_to_next_node / speed;
	if (delta > time_to_next_node):
		print("Corner!")
		path.remove(0)
	
	
	var movement_vec = (path[0] - position).normalized() * delta * speed
	rotation = movement_vec.normalized().rotated(PI / 2).angle()
	var collision = move_and_collide(movement_vec)
	if collision and ! dead:
		collision.collider.collide()
		collide()

func collide():
	dead = true
	_ref_Nodes.remove_from_nodes(self)
	self.queue_free()
