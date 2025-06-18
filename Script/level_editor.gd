extends Node2D

const In_edit_mode:= false

var fk_output_array:= [[],[],[],[]]
var fk_holding_output_array:= [[],[],[],[]]
var FallingTime := 1.91666666666676
var CurrentLevelName := "Eternal_City"

@onready var audio_stream_player: AudioStreamPlayer = %AudioStreamPlayer
@export var LevelInfo: Level



func _ready() -> void:
	call_deferred("_setup_level")
	
func _setup_level():
	audio_stream_player.stream = LevelInfo.music
	audio_stream_player.play()
	if In_edit_mode:
		Global.EditoKeyListenrPress.connect(KeyListenerPress)
		Global.EditoHoldingKeyPress.connect(HoldingKeyPress)
	else: 
		var fk_times = LevelInfo.fk_times
		var fk_times_array = str_to_var(fk_times)
		var fh_times = LevelInfo.fk_hold
		var fh_times_array = str_to_var(fh_times) 
		var CurrentKey:=0
		for Key in fk_times_array: #KEY ARRAY
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
			for hold_data in fh_times_array[CurrentKey]: # Each is [start_time, duration]
				var hold_start = hold_data[0]
				var hold_duration = hold_data[1]
				SpawnHoldKey(button_name, hold_start, hold_duration)
			CurrentKey +=1 # NEXT KEY
#<---------------------- FOR PLAYER --------------------->
func SpawmFallkingKey(button_name: String, delay: float):
	Global.CreateFallkingKey.emit(button_name,delay-FallingTime)
func SpawnHoldKey(button_name: String, start: float, duration: float):
	var StartTime = start-FallingTime
	Global.CreateHoldingKey.emit(button_name,duration,StartTime)
#<----------------------- FOR EDITOR ------------------------>
func KeyListenerPress(button_name: String,array_index:int):
	while fk_output_array.size() <= array_index: fk_output_array.append([])
	var CurrentTime = audio_stream_player.get_playback_position() 
	fk_output_array[array_index].append(CurrentTime)
func HoldingKeyPress(button_name: String,array_index:int, duration: float):
	while fk_holding_output_array.size() <= array_index: fk_holding_output_array.append([])
	var StartTime = audio_stream_player.get_playback_position() - duration
	var hold_data = [StartTime,duration]
	print ("RECORD START: ", StartTime)
	print("RECORD DURATION: ", duration)
	print("RECORD END: ", audio_stream_player.get_playback_position())
	fk_holding_output_array[array_index].append(hold_data)
func _on_audio_stream_player_finished() -> void:
	if In_edit_mode: 
		var save_path = LevelInfo.resource_path
		LevelInfo.fk_times = str(fk_output_array)
		LevelInfo.fk_hold = str(fk_holding_output_array)
		ResourceSaver.save(LevelInfo,save_path)
	else: Global.SongFinished.emit()

func create_pause_aware_timer(time: float) -> Timer:
	var timer := Timer.new()
	timer.one_shot = true
	timer.wait_time = time
	timer.process_mode = Timer.ProcessMode.PROCESS_MODE_WHEN_PAUSED  # This makes it pause with the game
	add_child(timer)  # Add to current scene, so it's removed when scene changes
	timer.start()
	return timer
