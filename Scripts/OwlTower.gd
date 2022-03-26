extends Node2D

var _Groups := preload("res://Scripts/Library/Groups.gd").new()

export var targeting_range: float = 200
export var price: int = 20
export var bullets_per_second: float = 2
export var inaccuracy_degrees: float = 20
var bullet_timer: float = 0.3

const Bullet := preload("res://Assets/Bullet.tscn")
const Nodes := preload("res://Scripts/Nodes.gd")
var _ref_Nodes: Nodes
var _prev_emitter: int = 0
var _bullet_emitters: = []


func _ready():
	_ref_Nodes = get_node("/root/MainScene/Nodes")
	_bullet_emitters.append(get_node("./BulletEmitter1"))
	_bullet_emitters.append(get_node("./BulletEmitter2"))

func _process(delta):
	bullet_timer += delta * bullets_per_second
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
			var current_emitter = _prev_emitter + 1
			current_emitter = current_emitter % _bullet_emitters.size()
			
			get_parent().add_child(new_node)
			new_node.position = _bullet_emitters[current_emitter].global_position
			new_node.start_pos = _bullet_emitters[current_emitter].global_position
			new_node.target_pos = closest_enemy.position
			new_node.max_range = targeting_range * 1.5
			new_node.inaccuracy_degrees = inaccuracy_degrees
			
			_prev_emitter = current_emitter
	
	if bullet_timer < 0.2:
		$OwlShoot.visible = true
		$OwlIdle.visible = false
	else:
		$OwlShoot.visible = false
		$OwlIdle.visible = true
	
	if not enemy_found:
		if bullet_timer > 1:
			bullet_timer = 1
