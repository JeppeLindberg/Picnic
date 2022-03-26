extends Node2D

const Enemy := preload("res://Assets/Enemy.tscn")

var _health_display: = []
var _money_display: Label
var _wave_display: Label
var _enemy_spawn_top_left: Node2D
var _enemy_spawn_bottom_right: Node2D

export var seconds_between_rounds = 5
export var round_spawn_duration_base = 5.0
export var round_spawn_duration_scaling = 1.0
export var round_spawn_count_base = 10
export var round_spawn_count_scaling = 5

var current_health = 5
var current_money = 50

var _current_wave = 0
var _current_wave_start_time: int
var _current_wave_remaining_spawns: int
var _spawns_per_sec: float
var _last_wave_end_time: int
var _ongoing_wave: bool
var _spawn_timer: float

var rng = RandomNumberGenerator.new()


func lose_money(subtraction):
	current_money -= subtraction
	
	update_display()

func lose_health():
	current_health -= 1
	
	if current_health == 0:
		get_tree().change_scene("res://Scenes/GameOver.tscn")
	
	update_display()

func update_display():	
	for node in _health_display:
		node.visible = false
	for i in range(0,current_health):
		_health_display[i].visible = true
		
	_money_display.text = " x " + String(current_money)
	_wave_display.text = "Wave " + String(_current_wave)
	
func _process(delta):
	if (_ongoing_wave == false) and \
	(OS.get_ticks_msec() - _last_wave_end_time) > (seconds_between_rounds * 1000):
		_current_wave += 1
		_ongoing_wave = true
		_current_wave_start_time = OS.get_ticks_msec()
		_current_wave_remaining_spawns = round_spawn_count_base + round_spawn_count_scaling * _current_wave
		_spawn_timer = 0
		_spawns_per_sec = _current_wave_remaining_spawns / (round_spawn_duration_base + round_spawn_duration_scaling*_current_wave)
		update_display()
	
	if _ongoing_wave and (_current_wave_remaining_spawns > 0):
		_spawn_timer += _spawns_per_sec*delta
		if _spawn_timer > 1:
			_spawn_timer -= 1
			_current_wave_remaining_spawns -= 1
			spawn_enemy()
			
func spawn_enemy():
	var x = rng.randf_range(_enemy_spawn_top_left.global_position.x, _enemy_spawn_bottom_right.global_position.x)
	var y = rng.randf_range(_enemy_spawn_top_left.global_position.y, _enemy_spawn_bottom_right.global_position.y)
	var spawn_loc = Vector2(x, y)
	
	var enemy = Enemy.instance() as Node2D
	get_parent().add_child(enemy)
	enemy.position = spawn_loc
	
func end_wave():
	_ongoing_wave = false
	_last_wave_end_time = OS.get_ticks_msec()

func _ready():
	rng.randomize()
	_health_display.append(get_node("/root/MainScene/GUI/RightBottom/HealthContainer/Health1"))
	_health_display.append(get_node("/root/MainScene/GUI/RightBottom/HealthContainer/Health2"))
	_health_display.append(get_node("/root/MainScene/GUI/RightBottom/HealthContainer/Health3"))
	_health_display.append(get_node("/root/MainScene/GUI/RightBottom/HealthContainer/Health4"))
	_health_display.append(get_node("/root/MainScene/GUI/RightBottom/HealthContainer/Health5"))
	_health_display.append(get_node("/root/MainScene/GUI/RightBottom/HealthContainer/Health6"))
	_money_display = get_node("/root/MainScene/GUI/RightBottom/MoneyContainer/Label")
	_wave_display = get_node("/root/MainScene/GUI/Top/WaveContainer/Label")
	_enemy_spawn_top_left = get_node("/root/MainScene/EnemySpawn/TopLeft")
	_enemy_spawn_bottom_right = get_node("/root/MainScene/EnemySpawn/BottomRight")
	
	_last_wave_end_time = OS.get_ticks_msec()
	_ongoing_wave = false
	
	update_display()
