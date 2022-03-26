extends KinematicBody2D

var _StageCoords := preload("res://Scripts/Library/StageCoords.gd").new()
var _Groups := preload("res://Scripts/Library/Groups.gd").new()
const Pickup := preload("res://Assets/Pickup.tscn")

export var money_drop_chance: float = 0.2
var drops_money = true

var initialized = false
var start_pos: Vector2
var target_pos: Vector2
var dead = false
export var speed: float
export (int) var position_offset_stages = 2
export (Vector2) var position_offset = Vector2(32, 32)
var rng = RandomNumberGenerator.new()

const Nodes := preload("res://Scripts/Nodes.gd")
var _ref_Nodes: Nodes

var path : PoolVector2Array

func random_vector(maxSize : Vector2):
	return Vector2(rng.randf_range(maxSize.x / -2, maxSize.x / 2), rng.randf_range(maxSize.y / -2, maxSize.y / 2))

func mess_path(points : PoolVector2Array):
	var state = random_vector(position_offset)
	# print("Messing points")
	for i in range(points.size()):
		#print("   Offset state of " + str(state))
		points[i] += state
		state = (state * (position_offset_stages - 1) +  random_vector(position_offset)) / position_offset_stages
	return points

func set_route(points : PoolVector2Array):
	path = points

func pathfind(astar : AStar2D):
	var start_point = astar.get_closest_point(position)
	var route = astar.get_point_path(start_point, 0)
	if route.empty():
		print("Enemy unable to find path. This should never happen")
		route.push_back(target_pos)
	set_route(mess_path(route))

func _ready():
	add_to_group(_Groups.ENEMY)
	_ref_Nodes = get_node("/root/MainScene/Nodes")
	_ref_Nodes.add_node(self)
	rng.randomize()
	
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
		# print("Corner!")
		path.remove(0)
	
	
	var movement_vec = (path[0] - position).normalized() * delta * speed
	rotation = movement_vec.normalized().rotated(PI / 2).angle()
	var collision = move_and_collide(movement_vec)
	if collision and ! dead:
		if collision.collider.is_in_group(_Groups.CAKE):
			drops_money = false
		collision.collider.collide()
		collide()

func collide():
	dead = true
	_ref_Nodes.remove_from_nodes(self)
	if drops_money:
		if rng.randf() < money_drop_chance:
			var new_node = Pickup.instance()
			get_parent().add_child(new_node)
			new_node.position = position
	self.queue_free()
