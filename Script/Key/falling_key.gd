extends Sprite2D
class_name FallingKey
@export var FallingSpeed :=500
var PresskeyNode: PressKey
var UniqeName :String
var TargetKey_Y_Position:int
var TargetKey_Press_offSet:= 100
var IsActivate :=false

@export_category("Point")
@export var Miss_point := 0
@export var Good_point := 20
@export var Great_point :=50
@export var Perfect_point :=100

@export_category("Position")
@export var Miss_position := 100
@export var Good_position := 50
@export var Great_position := 35
@export var Perfect_position := 15
var Music: AudioStreamPlayer
var delay:float
func _ready() -> void:
	await  self.ready
	Global.ChangeActiveWhenChangeSence.connect(queue_free)
func _exit_tree():
	PresskeyNode.unregister_falling_key(self)
func _process(delta: float) -> void:
	if !IsActivate: return
	position.y += FallingSpeed * delta
	#CACULATE THE FALLING TIME IF NEED
	#if abs(TargetKey_Y_Position - position.y) <= 5:
		#var now = Music.get_playback_position()
		#print("MUSIC TIME: ", now, " - ",)
	if position.y > TargetKey_Y_Position + Good_position:
		Global.PointInc.emit(Miss_point)
		queue_free()
func _input(event: InputEvent) -> void:
	var main_game_node =  get_tree().get_nodes_in_group("main_game")
	var closetNode =  PresskeyNode.get_closest_key()
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
func SetUp(PressKeyNodeP: PressKey,Delay:float):
	await self.ready
	Music = get_tree().get_first_node_in_group("Music")
	$ActivateTimer.start(Delay)
	PressKeyNodeP.register_falling_key(self)
	PresskeyNode = PressKeyNodeP
	position.y = -100
	position.x = PressKeyNodeP.position.x
	TargetKey_Y_Position = PressKeyNodeP.position.y
	rotation = PressKeyNodeP.rotation
	UniqeName = PressKeyNodeP.UniqueName
	modulate = PressKeyNodeP.KeyColor
func _on_activate_timer_timeout() -> void:
	IsActivate = true
	$ReachPressKey.start()
