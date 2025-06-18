extends Sprite2D
class_name FallingKey
@export var FallingSpeed :=5.5

var UniqeName :String
var TargetKey_Y_Position:int
var TargetKey_Press_offSet:= 100
var IsActivate :=false

var Miss_point := 0
var Good_point := 20
var Great_point :=50
var Perfect_point :=100


var Miss_position := 100
var Good_position := 50
var Great_position := 35
var Perfect_position := 15

func _ready() -> void:
	await  self.ready
	$ReachPressKey.start()
	Global.register_falling_key.emit(UniqeName, self)
	Global.ChangeActiveWhenChangeSence.connect(queue_free)
func _exit_tree():
	Global.unregister_falling_key.emit(UniqeName, self)
func _process(delta: float) -> void:
	if !IsActivate: 
		return
	position.y += FallingSpeed
	#CACULATE THE FALLING TIME IF NEED
	#if abs(TargetKey_Y_Position - position.y) <=15: print(abs($ReachPressKey.time_left - $ReachPressKey.wait_time))
	if position.y > TargetKey_Y_Position + Good_position:
		Global.PointInc.emit(Miss_point)
		queue_free()
func _input(event: InputEvent) -> void:
	var main_game_node =  get_tree().get_nodes_in_group("main_game")
	var closetNode: Node
	main_game_node = main_game_node[0]
	closetNode =  main_game_node.get_closest_falling_key(UniqeName)
	var DistanceToPressArrow = abs(TargetKey_Y_Position - position.y)
	if DistanceToPressArrow > Miss_position: return
	if event.is_action_pressed(UniqeName) && self == closetNode: 
		if DistanceToPressArrow < Perfect_position: 
			Global.PointInc.emit(Perfect_point)
			queue_free()
		elif  DistanceToPressArrow < Great_position: 
			Global.PointInc.emit(Great_point)
			queue_free()
		elif DistanceToPressArrow < Good_position: 
			Global.PointInc.emit(Good_point)
			queue_free()
		elif DistanceToPressArrow < Miss_position:
			Global.PointInc.emit(Miss_point)
			queue_free()
		else: Global.PointInc.emit(Miss_point)
func SetUp(ArrowPosition: Vector2, ArrowName: String, Arrowrrotation:float, KeyColor: Color,delay:float):
	await self.ready
	$ActivateTimer.start(delay)
	position.y = -100
	position.x = ArrowPosition.x
	TargetKey_Y_Position = ArrowPosition.y
	rotation = Arrowrrotation
	UniqeName = ArrowName
	modulate = KeyColor

func SetActivate(value:bool,timer_has_start: bool):
	if name == "FallkingKey":
		print("BEFORE: ",IsActivate)
		print("TIMER HAS START: ", timer_has_start)
	IsActivate = value


func _on_activate_timer_timeout() -> void:
	SetActivate(true,false)
