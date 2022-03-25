extends Node2D

var _Groups := preload("res://Scripts/Library/Groups.gd").new()

export var targeting_range: float
var bullet_timer: float

const Bullet := preload("res://Assets/Bullet.tscn")
const Nodes := preload("res://Scripts/Nodes.gd")
var _ref_Nodes: Nodes


func _ready():
	_ref_Nodes = get_node("/root/MainScene/Nodes")

func _process(delta):
	bullet_timer += delta
	var enemy_nodes = _ref_Nodes.get_all_nodes_in_group(_Groups.ENEMY)
	var enemy_found = false
	
	var distance_to_closest_enemy:float = 100000
	var closest_enemy: Node2D
	
	for node in enemy_nodes:
		if node.position.distance_to(position) < targeting_range:
			enemy_found = true
			if position.distance_to(node.position) < distance_to_closest_enemy:
				closest_enemy = node
				distance_to_closest_enemy = position.distance_to(node.position)
	
	if enemy_found:
		rotation = (closest_enemy.position - position).normalized().rotated(PI / 2).angle()
		if bullet_timer > 1:
			bullet_timer -= 1
			
			var new_node = Bullet.instance() as Node2D
			get_parent().add_child(new_node)
			new_node.position = position
			new_node.start_pos = position
			new_node.target_pos = closest_enemy.position
	
	if not enemy_found:
		if bullet_timer > 1:
			bullet_timer = 1
