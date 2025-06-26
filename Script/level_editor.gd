extends Node2D

var In_edit_mode:= false

var fk_output_array:= [[],[],[],[]]
var fk_holding_output_array:= [[],[],[],[]]
var FallingTime := 1.28320500000006


var CurrentLevelName := "Eternal_City"

@onready var audio_stream_player: AudioStreamPlayer = %AudioStreamPlayer
@export var LevelInfo: Level



func _ready() -> void:
	call_deferred("_setup_level")
	Global.ChangeMusicVolume.connect(ChangeMusicVolume)
	In_edit_mode= Global.EditMode
func _setup_level():
	audio_stream_player.stream = LevelInfo.music
	audio_stream_player.play()
	if In_edit_mode:
		Global.EditoKeyListenrPress.connect(FallingKeyPress)
		Global.EditoHoldingKeyPress.connect(HoldingKeyPress)
	else: 
		var fk_times = LevelInfo.fk_times
		var fk_times_array = str_to_var(fk_times)
		var fh_times = LevelInfo.fk_hold
		var fh_times_array = str_to_var(fh_times) 
		var CurrentKey:=0
		for Key in fk_times_array: #KEY ARRAY - (Up/Down/Left/Right)
			var button_name :=""
			match CurrentKey:
				0: button_name = "Left"
				1: button_name = "Down"
				2: button_name = "Up"
				3: button_name = "Right"
			#SPAWM FALLING KEY
			for delay in Key: #DELAY ARRAY
				SpawmFallkingKey(button_name,delay)
			# SPAWN HOLD KEY
			for hold_data in fh_times_array[CurrentKey]: # Each data is [start_time, duration]
				var hold_start = hold_data[0]
				var hold_duration = hold_data[1]
				SpawnHoldKey(button_name, hold_start, hold_duration)
			CurrentKey +=1 # MOVE TO NEXT KEY
#<---------------------- FOR PLAYER --------------------->
func SpawmFallkingKey(button_name: String, CreatTime: float):
	var PressTime: float = CreatTime - FallingTime
	Global.CreateFallkingKey.emit(button_name,PressTime)
func SpawnHoldKey(button_name: String, CreatTime: float, duration: float):
	var PressTime = CreatTime-FallingTime
	Global.CreateHoldingKey.emit(button_name,duration,PressTime)
#<----------------------- FOR EDITOR ------------------------>
func FallingKeyPress(button_name: String,array_index:int,startTime: float):
	while fk_output_array.size() <= array_index: fk_output_array.append([])
	fk_output_array[array_index].append(startTime)
func HoldingKeyPress(button_name: String,array_index:int, duration: float):
	while fk_holding_output_array.size() <= array_index: fk_holding_output_array.append([])
	var StartTime = audio_stream_player.get_playback_position() - duration
	var hold_data = [StartTime,duration]
	fk_holding_output_array[array_index].append(hold_data)
func _on_audio_stream_player_finished() -> void:
	if In_edit_mode: 
		var save_path = LevelInfo.resource_path
		LevelInfo.fk_times = str(fk_output_array)
		LevelInfo.fk_hold = str(fk_holding_output_array)
		ResourceSaver.save(LevelInfo,save_path)
		print("SONG END")
	else: Global.SongFinished.emit()
func ChangeMusicVolume(value: float):
	audio_stream_player.volume_db = value
	#print(audio_stream_player.volume_db)
