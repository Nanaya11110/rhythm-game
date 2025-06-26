extends Control

@onready var main_background: TextureRect = %MainBackground
@onready var songs_container: VBoxContainer = %SongsContainer
@onready var SongInfoImage: TextureRect = %SongBigImage
@onready var background_music: AudioStreamPlayer = %BackgroundMusic
@onready var set_song_background_button: Button = %SetSongBackgroundButton
@onready var setting_menu: Panel = %SettingMenu
@onready var edit_mode_check_button: CheckButton = %EditModeCheckButton
@onready var main_ui_container: HBoxContainer = $MainUIContainer
@onready var setting_button_container: MarginContainer = %SettingButtonContainer



var NewSong: Level
var SongsArray: Array
var CurrentSong: Level
var last_selected_button :Button
var HasSortFirstSong:= false


func _ready() -> void:
	for i in songs_container.get_child_count():
		var song = songs_container.get_child(i)
		song.Id = i
		SongsArray.append(song)
	edit_mode_check_button.button_pressed = Global.EditMode
	SetEditModeToggleButtonColor(Global.EditMode)
	PickedSong(0)
	
	Global.ChangeMusicVolume.connect(ChangeMusicVolume)
	Global.ChangeSoundEffectVolume.connect(ChangeSoundEffectVolume)
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Exit") && setting_menu.visible == true:
		setting_menu.visible = false
	
func PickedSong(Id):
	CurrentSong = SongsArray[Id].SongInfo
	main_background.texture = CurrentSong.BackgroundImage
	SongInfoImage.texture = CurrentSong.BackgroundImage
	background_music.stream = CurrentSong.music
	background_music.play()
	#Setting the Set Background button
	if !CurrentSong.BackgroundMV: 
		set_song_background_button.text = "BG"
		set_song_background_button.disabled = true
	else: 
		set_song_background_button.disabled = false
		if CurrentSong.HasMv: set_song_background_button.text = "MV"
		else:  set_song_background_button.text = "BG"
	var SongButton: Button = songs_container.get_child(Id)
	# Revert previous selected song button
	if last_selected_button and last_selected_button != SongButton:
		var original_normal = get_theme_stylebox("normal", "Button").duplicate()
		var original_hover = get_theme_stylebox("hover", "Button").duplicate()
		original_hover.bg_color = Color("63597a")
		original_normal.bg_color = Color("63597a")
		last_selected_button.add_theme_stylebox_override("normal", original_normal)
		last_selected_button.add_theme_stylebox_override("hover", original_hover)
	# Highlight current button
	var selected_normal = SongButton.get_theme_stylebox("normal", "Button").duplicate()
	var selected_hover = SongButton.get_theme_stylebox("hover", "Button").duplicate()
	selected_normal.bg_color = Color("ff55ab")
	selected_hover.bg_color = Color("ff55ab")
	SongButton.add_theme_stylebox_override("normal", selected_normal)
	SongButton.add_theme_stylebox_override("hover", selected_hover)

	last_selected_button = SongButton
func _on_setting_button_pressed() -> void:
	setting_menu.visible = true
func ChangeMusicVolume(value: float):
	background_music.volume_db = value
func ChangeSoundEffectVolume(value: float):
	$SoundEffecCheck.volume_db = value
	$SoundEffecCheck.stop()
	$SoundEffecCheck.play()
#-----------UNIT BUTTON----------
func _on_all_song_button_pressed() -> void:
	for songButton in songs_container.get_children():
		songButton.visible = true
func _on_eternal_city_song_button_pressed() -> void:
	HasSortFirstSong = false
	for songButton in songs_container.get_children():
		if songButton.SongInfo.category == 0: 
			songButton.visible = true
			if !HasSortFirstSong: 
				PickedSong(songButton.Id)
				HasSortFirstSong = true
		else: songButton.visible = false
func _on_project_sekai_song_button_pressed() -> void:
	HasSortFirstSong = false
	for songButton in songs_container.get_children():
		if songButton.SongInfo.category == 1: 
			songButton.visible = true
			if !HasSortFirstSong: 
				PickedSong(songButton.Id)
				HasSortFirstSong = true
		else: 
			songButton.visible = false
func _on_heaven_burn_red_song_button_pressed() -> void:
	HasSortFirstSong = false
	for songButton in songs_container.get_children():
		if songButton.SongInfo.category == 2: 
			songButton.visible = true
			if !HasSortFirstSong: 
				PickedSong(songButton.Id)
				HasSortFirstSong = true
		else: 
			songButton.visible = false



#--------ALL EDIT BUTTONS---------
func _on_set_song_background_button_pressed() -> void:
	CurrentSong.HasMv =  !CurrentSong.HasMv
	if CurrentSong.HasMv:  set_song_background_button.text = "MV"
	else: set_song_background_button.text = "BG"
	
func SetEditModeToggleButtonColor(value: bool)-> void:
	var original_style_box = edit_mode_check_button.get_theme_stylebox("normal","Button")
	var change_style_box = original_style_box.duplicate()
	var test_style_box = change_style_box.duplicate()
	test_style_box.bg_color =Color.BLACK
	if value == false: change_style_box.bg_color = Color("888C93") #Gray
	else: change_style_box.bg_color = Color("00E0FF") #Blue
	edit_mode_check_button.add_theme_stylebox_override("normal", change_style_box)
	edit_mode_check_button.add_theme_stylebox_override("hover", change_style_box)
	edit_mode_check_button.add_theme_stylebox_override("pressed", change_style_box)
	edit_mode_check_button.add_theme_stylebox_override("focus", change_style_box)
func _on_edit_mode_check_button_toggled(toggled_on: bool) -> void:
	Global.EditMode = toggled_on
	SetEditModeToggleButtonColor(toggled_on)
func _on_play_button_pressed() -> void:
	Global.CurrentSong = CurrentSong
	get_tree().change_scene_to_file("res://Sence/UI/main_game.tscn")
