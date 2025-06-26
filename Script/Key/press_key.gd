extends Sprite2D
class_name PressKey
const FALLKING_KEY = preload("res://Sence/Key/falling_key.tscn")
const HOLDING_KEY = preload("res://Sence/Key/holding_key.tscn")
var All_Key: Array[Node]
var hold_start_time :=0.0
var hold_end_time :=0.0
var is_tap :=false
var is_holding :=false
@onready var effect_sprite: Sprite2D = $EffectSprite
@onready var press_sound_effect: AudioStreamPlayer = %PressSoundEffect
@export var UniqueName := ""
@export var UniqueKey :=0
@export var KeyColor: Color

func _ready() -> void:
	Global.CreateFallkingKey.connect(CreateFallingKey)
	Global.CreateHoldingKey.connect(CreateHoldingKey)
	Global.ChangeSoundEffectVolume.connect(ChangeSoundEffectVolume)
	effect_sprite.texture = texture
	effect_sprite.self_modulate = KeyColor
func _process(delta: float) -> void:
	if Input.is_action_just_pressed(UniqueName):
		KeyPressEffect()
		hold_start_time = get_tree().get_first_node_in_group("Music").get_playback_position()
		is_holding = false
		$HoldCheckingTimer.start()
		# ✅ Record tap immediately if it's not a hold (we’ll fix that later on release)
	elif Input.is_action_just_released(UniqueName):
		if is_holding:
			var hold_end_time = get_tree().get_first_node_in_group("Music").get_playback_position()
			var hold_duration = hold_end_time - hold_start_time
			Global.EditoHoldingKeyPress.emit(UniqueName, UniqueKey, hold_duration)
		else:
			Global.EditoKeyListenrPress.emit(UniqueName, UniqueKey, hold_start_time)
			$HoldCheckingTimer.stop()

func CreateFallingKey(button_name: String,delay: float):
	if !button_name == UniqueName: return
	var FallingKeyIns = FALLKING_KEY.instantiate()
	get_tree().get_root().call_deferred("add_child",FallingKeyIns)
	FallingKeyIns.SetUp(self,delay)
func CreateHoldingKey(button_name: String,duration:float,delay: float):
	if !button_name == UniqueName: return
	var HoldingKeyIns = HOLDING_KEY.instantiate()
	HoldingKeyIns.SetUp(self,duration,delay)
	get_tree().get_root().call_deferred("add_child",HoldingKeyIns)

#---------- FOR FALLING/HOLDING KEY USE ----------
func register_falling_key(node: Node):
	All_Key.append(node)
func unregister_falling_key(node: Node):
	All_Key.erase(node)
func get_closest_key() -> Node:
	if All_Key.is_empty(): 
		print("EMPTY")
		return null
	var ClosetKey: Node = null
	var ClosetDistance := INF
	for key in All_Key:
		if not key.IsActivate: continue
		var distance =  abs(key.position.y - key.TargetKey_Y_Position)
		if distance < ClosetDistance:
			ClosetDistance = distance
			ClosetKey = key
	return ClosetKey

func KeyPressEffect():
	$AnimationPlayer.stop()
	$AnimationPlayer.play("Fade_in")
	press_sound_effect.stop()
	press_sound_effect.play()
	
func _on_hold_checking_timer_timeout() -> void:
	is_holding = true
func ChangeSoundEffectVolume(value: float):
	press_sound_effect.volume_db = value
