extends RigidBody2D

var _spawn_time: int


func _ready():
	_spawn_time = OS.get_ticks_msec()
	
func _process(delta):
	if (OS.get_ticks_msec() - _spawn_time)/1000 > 0.15:
		self.queue_free()

func collide():
	pass
