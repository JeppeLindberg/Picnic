extends Node2D

export (Array, Texture) var flower_sprites

var _Groups := preload("res://Scripts/Library/Groups.gd").new()

var _ref_GameState: Node2D
var _sprite: Node2D
var _rot: float
var _picked_up: bool = false
var _picked_up_time: float = 0
var _money_dropoff: Control
var _picked_up_loc: Vector2

var rng = RandomNumberGenerator.new()

func _ready():
	_ref_GameState = get_node("/root/MainScene/GameState")
	_sprite = get_node("./Sprite")
	_money_dropoff = get_node("/root/MainScene/GUI/RightBottom/MoneyContainer/Money")
	rng.randomize()
	add_to_group(_Groups.PICKUP)
	get_node("./Sprite").texture = flower_sprites[rng.randi_range(0, flower_sprites.size()-1)]
	_rot = rng.randf()

func _process(delta):
	if _picked_up:
		var time_since: float = (OS.get_ticks_msec() - _picked_up_time)/1000
		var target_vec = _money_dropoff.rect_global_position
		target_vec += Vector2(56/2, 64/2) #Target vec is center of GUI element
		position = lerp(_picked_up_loc, target_vec, time_since*time_since)
		if time_since > 1:
			_ref_GameState.gain_money(1)
			self.queue_free()
	else:
		_rot += delta/10
		if _rot > 1:
			_rot -= 1
		_sprite.rotation = _rot * (PI * 2)

func _on_Pickup_mouse_entered():
	pass

func hover_mouse():
	pick_up()

func pick_up():
	if not _picked_up:
		_picked_up = true
		_picked_up_time = OS.get_ticks_msec()
		_picked_up_loc = position
