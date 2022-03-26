extends Node2D

export (Array, Texture) var flower_sprites

var _Groups := preload("res://Scripts/Library/Groups.gd").new()

const GameState := preload("res://Scripts/GameState.gd")
var _ref_GameState: GameState

var rng = RandomNumberGenerator.new()

func _ready():
	_ref_GameState = get_node("/root/MainScene/GameState")
	rng.randomize()
	add_to_group(_Groups.PICKUP)
	get_node("./Sprite").texture = flower_sprites[rng.randi_range(0, flower_sprites.size()-1)]

func hover_mouse():
	_ref_GameState.gain_money(1)
	self.queue_free()
