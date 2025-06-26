extends Node2D
class_name HoldingKey

@export var FallingSpeed :=500
var hold_duration:= 0.0
var UniqeName :String
var PressKeyNode: PressKey
var TargetKey_Y_Position:=0
var TargetKey_Press_offSet:= 100
var Is_holding :=false 
var Has_SetUp:= false
var IsActivate :=false

@export_category("Point")
@export var Miss_point := 0
@export var Good_point := 20
@export var Greate_point :=50
@export var Perfect_point :=100

@export_category("Position")
@export var Miss_position := 100
@export var Good_position := 50
@export var Great_position := 35
@export var Perfect_position := 15

func _ready() -> void:
	await self.ready
	Global.ChangeActiveWhenChangeSence.connect(queue_free)
func _exit_tree() -> void:
	PressKeyNode.unregister_falling_key(self)
func _process(delta: float) -> void:
	if !IsActivate: return
	#CACULATE THE FALLING TIME IF NEED
	#if abs(TargetKey_Y_Position - position.y) <=15: printerr(abs($ReachListenerTimer.time_left - $ReachListenerTimer.wait_time))
	#DONT MOVE THE START IF HOLDING, JUST MOVE THE DURATION AND END POINT
	if !Is_holding: position.y += FallingSpeed * delta
	else:
		$DurationEndPoint.position.y += FallingSpeed * delta
		var line_end = Vector2(0, $DurationEndPoint.position.y)
		%DurationLine.points = PackedVector2Array([Vector2.ZERO, line_end])
		#print($DurationEndPoint.position)
	#HAS PASS THE LISTENER KEY
	if global_position.y > TargetKey_Y_Position + TargetKey_Press_offSet || $DurationEndPoint.global_position.y > TargetKey_Y_Position + TargetKey_Press_offSet: 
		Global.PointInc.emit(Miss_point)
		queue_free()

func _input(event: InputEvent) -> void:
	if !IsActivate: return
	#CHECK IF THIS IS THE CLOSET KEY
	var closetNode =  PressKeyNode.get_closest_key()
	var DistanceToPressArrow = TargetKey_Y_Position - position.y
	var DistanceWhenRelese = (position.y - $DurationEndPoint.position.y) - TargetKey_Y_Position
	#DONT CHECK IF NOT IN RANGE
	if DistanceToPressArrow > Miss_position: return
	#WHEN HOLDING
	if event.is_action_pressed(UniqeName) && closetNode == self: 
		Is_holding = true
		if DistanceToPressArrow < Perfect_position: 
			Global.PointInc.emit(Perfect_point)
		elif  DistanceToPressArrow < Great_position: 
			Global.PointInc.emit(Greate_point)
		elif DistanceToPressArrow < Good_position: 
			Global.PointInc.emit(Good_point)
		else: Global.PointInc.emit(Miss_point)
	# WHEN RELESE
	elif event.is_action_released(UniqeName) && closetNode == self && Is_holding == true: 
		Is_holding = false
		if DistanceWhenRelese < Perfect_position: 
			Global.PointInc.emit(Perfect_point)
			queue_free()
		elif  DistanceWhenRelese < Great_position: 
			Global.PointInc.emit(Greate_point)
			queue_free()
		elif DistanceWhenRelese < Good_position: 
			Global.PointInc.emit(Good_point)
			queue_free()
		else: 
			Global.PointInc.emit(Miss_point)
			queue_free()
	

func SetUp(PressKeyNodeP: PressKey,duration:float,delay:float):
	await self.ready
	$ActivateTimmer.start(delay)
	PressKeyNode = PressKeyNodeP
	PressKeyNodeP.register_falling_key(self)
	position.y = -100
	position.x = PressKeyNodeP.position.x
	TargetKey_Y_Position = PressKeyNodeP.position.y
	$Sprite2D.rotation = PressKeyNodeP.rotation
	$%EndSprite.rotation = PressKeyNodeP.rotation
	UniqeName = PressKeyNodeP.UniqueName
	modulate = PressKeyNodeP.KeyColor
	var Hold_height = -duration * FallingSpeed
	%DurationEndPoint.position = Vector2(0,Hold_height)
	%DurationLine.points = PackedVector2Array([Vector2.ZERO,%DurationEndPoint.position])
func SetActivate(value: bool):
	IsActivate = value
func _on_activate_timmer_timeout() -> void:
	SetActivate(true)
	$ReachListenerTimer.start()
