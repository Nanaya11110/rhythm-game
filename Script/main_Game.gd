extends Control

var falling_keys := {}  # "Button Name": [FallingKeyNode]
var holding_keys :={}   # "Button Name": [HoldingKeyNode]
var CurrentSong: Level
@onready var background: TextureRect = %Background
@onready var video_stream_player: VideoStreamPlayer = %VideoBackground



func _ready() -> void:
	Global.register_falling_key.connect(register_falling_key)
	Global.unregister_falling_key.connect(unregister_falling_key)
	CurrentSong = Global.CurrentSong
	if CurrentSong: $LevelEditor.LevelInfo = CurrentSong
	SetUpUI()
func SetUpUI():
	if !CurrentSong || CurrentSong == null: CurrentSong = $LevelEditor.LevelInfo
	background.texture = CurrentSong.BackgroundImage
	#SET UP MV
	if CurrentSong.HasMv: 
		video_stream_player.stream = CurrentSong.BackgroundMV
		video_stream_player.play()
		video_stream_player.volume_db = -80
func register_falling_key(key_name: String, node: Node):
	if node is FallingKey:
		if not falling_keys.has(key_name): 
			falling_keys[key_name] = []
		falling_keys[key_name].append(node)
	elif node is HoldingKey:
		if not holding_keys.has(key_name): 
			holding_keys[key_name] = []
		holding_keys[key_name].append(node)
func unregister_falling_key(key_name: String, node: Node):
	if node is FallingKey and falling_keys.has(key_name):
		falling_keys[key_name].erase(node)
	elif node is HoldingKey and holding_keys.has(key_name):
		holding_keys[key_name].erase(node)
func get_closest_falling_key(key_name: String):
	if !falling_keys.has(key_name): return null
	var keys = falling_keys[key_name]
	if keys.is_empty(): return null
	return keys[0]
	
func get_closest_holding_key(key_name: String) -> Node:
	if not holding_keys.has(key_name): return null
	var keys = holding_keys[key_name]
	if keys.is_empty(): return null
	var closest: Node = null
	var closest_dist := INF
	for key in keys:
		var dist = abs(key.global_position.y - key.TargetKey_Y_Position)
		if dist < closest_dist:
			closest = key
			closest_dist = dist
	return closest
