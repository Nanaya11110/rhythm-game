extends Node2D
class_name HoldingKey

@export var FallingSpeed :=5.5

var UniqeName :String
var TargetKey_Y_Position:=0
var TargetKey_Press_offSet:= 100
var Is_holding :=false 
var Has_SetUp:= false
var IsActivate :=false

var Good_point := 20
var Greate_point :=50
var Perfect_point :=100
var Miss_point := 0


var Miss_position := 100
var Good_position := 50
var Great_position := 35
var Perfect_position := 15

func _ready() -> void:
	await self.ready
	$ReachListenerTimer.start()
	Global.register_falling_key.emit(UniqeName, self)
	Global.ChangeActiveWhenChangeSence.connect(queue_free)
func _exit_tree() -> void:
	Global.unregister_falling_key.emit(UniqeName,self)
func _process(delta: float) -> void:
	if !IsActivate: return
	#CACULATE THE FALLING TIME IF NEED
	#if abs(TargetKey_Y_Position - position.y) <=15: print(abs($ReachListenerTimer.time_left - $ReachListenerTimer.wait_time))
	#DONT MOVE THE START IF HOLDING< JUST MOVE THE DURATION AND END POINT
	if !Is_holding: position.y += FallingSpeed
	else: 
		%DurationEndPoint.position.y +=FallingSpeed
		%DurationLine.points = PackedVector2Array([Vector2.ZERO,%DurationEndPoint.position])
	#HAS PASS THE LISTENER KEY
	if global_position.y > TargetKey_Y_Position + TargetKey_Press_offSet: 
		Global.PointInc.emit(Miss_point)
		queue_free()

func _input(event: InputEvent) -> void:
	if !IsActivate: return
	#CHECK IF THIS IS THE CLOSET KEY
	var closetNode: Node
	var main_game_node =  get_tree().get_nodes_in_group("main_game")
	if main_game_node: 
		main_game_node = main_game_node[0]
		closetNode =  main_game_node.get_closest_holding_key(UniqeName)
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
	

func SetUp(ArrowPosition: Vector2, ArrowName: String, Arrowrrotation:float, KeyColor: Color,duration:float,delay:float):
	await self.ready
	$ActivateTimmer.start(delay)
	position.y = -100
	position.x = ArrowPosition.x
	TargetKey_Y_Position = ArrowPosition.y
	$Sprite2D.rotation = Arrowrrotation
	$%EndSprite.rotation = Arrowrrotation
	UniqeName = ArrowName
	modulate = KeyColor
	var Hold_height = (duration * FallingSpeed * 60.0) *-1
	%DurationEndPoint.position = Vector2(0,Hold_height)
	%DurationLine.points = PackedVector2Array([Vector2.ZERO,%DurationEndPoint.position])
func SetActivate(value: bool):
	IsActivate = value
func _on_activate_timmer_timeout() -> void:
	SetActivate(true)
