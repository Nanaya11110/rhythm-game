extends Control

var falling_keys := {}  # "Button Name": [FallingKeyNode]
var holding_keys :={}   # "Button Name": [HoldingKeyNode]
var CurrentSong: Level
@onready var background: TextureRect = %Background
@onready var video_stream_player: VideoStreamPlayer = %VideoBackground



func _ready() -> void:
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
	
