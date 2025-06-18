extends Sprite2D

const FALLKING_KEY = preload("res://Sence/Key/falling_key.tscn")
const HOLDING_KEY = preload("res://Sence/Key/holding_key.tscn")
var hold_start_time :=0.0
var hold_end_time :=0.0
var is_tap :=false
var is_holding :=false
@onready var effect_sprite: Sprite2D = $EffectSprite
@export var UniqueName := ""
@export var UniqueKey :=0
@export var KeyColor: Color
func _ready() -> void:
	Global.CreateFallkingKey.connect(CreateFallingKey)
	Global.CreateHoldingKey.connect(CreateHoldingKey)
	effect_sprite.texture = texture
	effect_sprite.self_modulate = KeyColor

func _process(delta: float) -> void:
	if Input.is_action_just_pressed(UniqueName):
		# Start timer on press
		hold_start_time = get_tree().get_first_node_in_group("Music").get_playback_position()
		is_holding = false
		$HoldCheckingTimer.start()
		
	elif Input.is_action_just_released(UniqueName):
		# This is a tab
		if !is_holding:
			Global.EditoKeyListenrPress.emit(UniqueName, UniqueKey)
			$HoldCheckingTimer.stop()
		else:
			var hold_end_time = get_tree().get_first_node_in_group("Music").get_playback_position()
			var hold_duration = hold_end_time - hold_start_time
			Global.EditoHoldingKeyPress.emit(UniqueName, UniqueKey, hold_duration)

func CreateFallingKey(button_name: String,delay: float):
	if !button_name == UniqueName: return
	var FallingKeyIns = FALLKING_KEY.instantiate()
	get_tree().get_root().call_deferred("add_child",FallingKeyIns)
	FallingKeyIns.SetUp(position,UniqueName,rotation,KeyColor,delay)

func CreateHoldingKey(button_name: String,duration:float,delay: float):
	if !button_name == UniqueName: return
	var HoldingKeyIns = HOLDING_KEY.instantiate()
	HoldingKeyIns.SetUp(position,UniqueName,rotation,KeyColor,duration,delay)
	get_tree().get_root().call_deferred("add_child",HoldingKeyIns)

func KeyPressEffect():
	$AnimationPlayer.stop()
	$AnimationPlayer.play("Fade_in")


func _on_hold_checking_timer_timeout() -> void:
	is_holding = true
