extends Control


const MAIN_MENU = preload("res://Sence/UI/main_menu.tscn")
var PauseCountDownSecond :=3
var Point=0
var Combo:=0
var PerfectPressCount:= 0
var GreatPressCount:= 0 
var GoodPressCount:= 0
var MissPressCount:= 0
var ComboShowText := ""
var IsPause :=false

@onready var player_main_ui: Control = %PlayerMainUI
@onready var pause_menu: Control = %PauseMenu
@onready var win_menu: Control = %WinMenu
@onready var button_out_container: Panel = %ButtonOutContainer

@onready var point_label: Label = %PointLabel
@onready var combo_type_label: Label = %ComboShowLabel
@onready var combo_label: Label = %ComboLabel
@onready var count_down_label: Label = %CountDownLabel

@onready var perfect_win_label: Label = %PerfectWinLabel
@onready var great_win_label: Label = %GreatWinLabel
@onready var good_win_label: Label = %GoodWinLabel
@onready var miss_win_label: Label = %MissWinLabel
@onready var final_rank_label: Label = %FinalRankLabel




func _ready() -> void:
	Global.PointInc.connect(Callable(self,"PointInc"))
	Global.SongFinished.connect(func(): WinMenu(PerfectPressCount,GreatPressCount,GoodPressCount,MissPressCount))
	pause_menu.visible = false
	win_menu.visible = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Exit"): 
		if IsPause: Resume()
		else: Pause()

func PointInc(PointInc:int):
	Point += PointInc
	point_label.text = "Point: " + str(Point)
	match PointInc:
		20: 
			ComboShowText = "Good"
			combo_type_label.modulate = Color("00ffff") #BLUE
			GoodPressCount += 1
			ComboInc()
		50: 
			ComboShowText = "Great"
			combo_type_label.self_modulate = Color("fd0085") #PURPLE
			GreatPressCount +=  1
			ComboInc()
		100: 
			ComboShowText = "Perfect"
			combo_type_label.self_modulate = Color("cdcd00") #YELLOW
			PerfectPressCount += 1
			ComboInc()
		0: 
			ComboShowText = "Miss"
			combo_type_label.self_modulate = Color("797979") #GRAY
			MissPressCount += 1
			ComboReset()
	combo_type_label.text = ComboShowText
	$AnimationPlayer.play("Fade_in")
func ComboInc():
	Combo = Combo +1
	combo_label.text = "Combo: " + str(Combo)
func ComboReset():
	Combo =0
	combo_label.text = "Combo: " + str(Combo)

func Pause():
	get_tree().paused = true
	pause_menu.visible = true
	button_out_container.visible = true
func Resume():
	get_tree().paused = false
	pause_menu.visible = false
	count_down_label.visible = false
	PauseCountDownSecond = 4
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Fade_in": $AnimationPlayer.play("Fade_out")
	if anim_name == "countDownOut": $AnimationPlayer.play("countDownIn")
	if anim_name == "countDownIn": ResumeCountDown()

func ResumeCountDown():
	count_down_label.visible = true
	button_out_container.visible = false
	if PauseCountDownSecond == 0:  
		$AnimationPlayer.play("countDownOut")
		count_down_label.text = str(PauseCountDownSecond)
		Resume()
	else:
		$AnimationPlayer.play("countDownOut")
		count_down_label.text = str(PauseCountDownSecond)
		PauseCountDownSecond = PauseCountDownSecond - 1
		

func _on_exit_button_pressed() -> void:
	Resume()
	Global.emit_signal("ChangeActiveWhenChangeSence")
	get_tree().change_scene_to_packed(MAIN_MENU)
func _on_continute_button_pressed() -> void:
	ResumeCountDown()
func _on_restart_button_pressed() -> void:
	Resume()
	Global.emit_signal("ChangeActiveWhenChangeSence")
	await get_tree().process_frame
	get_tree().reload_current_scene()



func WinMenu(Perfect: int, Great: int, Good: int, Miss:int):
	player_main_ui.visible = false
	win_menu.visible = true
	perfect_win_label.text = "Perfect: " + str(Perfect)
	great_win_label.text = "Great: " + str(Great)
	good_win_label.text = "Good: " + str(Good)
	miss_win_label.text = "Miss: " + str(Miss)
	var FinalRank := CaculateFinalRank(Perfect,Great,Good,Miss)
	final_rank_label.text = "RANK: " + FinalRank
func CaculateFinalRank(Perfect: int, Great: int, Good: int, Miss: int) -> String:
	var TotalNotes := Perfect + Great + Good + Miss
	var Score := (Perfect * 1.0) + ( Great * 0.75) + (Good * 0.5) + (Miss * 0.0)
	var MaxScore := TotalNotes * 1.0
	var ratio:= Score / MaxScore
	if ratio >= 0.95: return "S"
	elif ratio >= 0.85: return "A"
	elif ratio >= 0.7:return "B"
	elif ratio >= 0.5: return "C"
	else: return "D"


func _on_continute_from_win_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Sence/UI/main_menu.tscn")
