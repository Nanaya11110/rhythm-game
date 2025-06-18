extends Node


signal PointInc(Point:int)
signal CreateFallkingKey(button_name: String,delay: float)
signal CreateHoldingKey(button_name: String, duration: float,delay: float)
signal EditoKeyListenrPress(button_name:String, array_index:int)
signal EditoHoldingKeyPress(button_name:String, array_index:int, duration: float)
signal register_falling_key(button_name: String, Key: PackedScene)
signal unregister_falling_key(button_name: String, Key: PackedScene)
signal ChangeActiveWhenChangeSence()
signal SongFinished()
var FK_speed:=5.5
var CurrentSong: Level
