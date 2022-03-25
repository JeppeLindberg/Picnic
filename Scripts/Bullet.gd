extends KinematicBody2D

var target_pos: Vector2
var start_pos: Vector2
export var speed: float


func _physics_process(delta):
	var movement_vec: Vector2
	movement_vec = (target_pos - start_pos).normalized() * delta * speed
	rotation = (target_pos - start_pos).normalized().rotated(PI / 2).angle()
	var collision = move_and_collide(movement_vec)
	if collision:
		collision.collider.collide()
		collide()
	

func collide():
	self.queue_free()
