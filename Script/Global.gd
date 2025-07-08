extends Node


signal PointInc(Point:int)
signal CreateFallkingKey(button_name: String,delay: float)
signal CreateHoldingKey(button_name: String, duration: float,delay: float)
signal EditoKeyListenrPress(button_name:String, array_index:int,start_time,float)
signal EditoHoldingKeyPress(button_name:String, array_index:int, duration: float)
signal ChangeActiveWhenChangeSence()
signal SongFinished()
signal ChangeMusicVolume(value: float)
signal ChangeSoundEffectVolume(value: float)

var Falling_Time:= 1.28320500000006
var CurrentSong: Level
var EditMode:= false
