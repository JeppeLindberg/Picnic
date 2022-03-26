extends KinematicBody2D

var _Groups := preload("res://Scripts/Library/Groups.gd").new()

const Pickup := preload("res://Assets/Pickup.tscn")

var target_pos: Vector2
var start_pos: Vector2
var max_range: float
var inaccuracy_degrees: float = 0
var inaccuracy_modulator: float = 0
export var speed: float
var initialized = false
var money_drop_chance: float = 0.2

var rng = RandomNumberGenerator.new()


func _physics_process(delta):
	if not initialized:
		rng.randomize()
		if inaccuracy_degrees > 0:
			inaccuracy_modulator = rng.randf_range(-inaccuracy_degrees, inaccuracy_degrees)/360.0
		initialized = true
		
	var movement_vec: Vector2
	movement_vec = (target_pos - start_pos).normalized() * delta * speed
	if inaccuracy_modulator != 0:
		movement_vec = movement_vec.rotated(inaccuracy_modulator * (PI * 2))
	
	rotation = movement_vec.normalized().rotated(PI / 2).angle()
	var collision = move_and_collide(movement_vec)
	if collision and not collision.collider.dead:
		collision.collider.collide()
		if collision.collider.is_in_group(_Groups.ENEMY):
			if rng.randf() < money_drop_chance:
				var new_node = Pickup.instance()
				get_parent().add_child(new_node)
				new_node.position = collision.position
		collide()
	if start_pos.distance_to(position) > max_range:
		self.queue_free()

func collide():
	self.queue_free()
