extends Control

@onready var main_background: TextureRect = %MainBackground
@onready var songs_container: VBoxContainer = %SongsContainer
@onready var SongInfoImage: TextureRect = %SongBigImage
@onready var background_music: AudioStreamPlayer = %BackgroundMusic
@onready var set_song_background_button: Button = %SetSongBackgroundButton

var SongsArray: Array
var CurrentSong: Level
var last_selected_button :Button
var HasSortFirstSong:= false


func _ready() -> void:
	for i in songs_container.get_child_count():
		var song = songs_container.get_child(i)
		song.Id = i
		SongsArray.append(song)
	PickedSong(0)

func PickedSong(Id):
	CurrentSong = SongsArray[Id].SongInfo
	main_background.texture = CurrentSong.BackgroundImage
	SongInfoImage.texture = CurrentSong.BackgroundImage
	background_music.stream = CurrentSong.music
	background_music.play()
	var SongButton: Button = songs_container.get_child(Id)
	# Revert previous selection
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

func _on_play_button_pressed() -> void:
	Global.CurrentSong = CurrentSong
	get_tree().change_scene_to_file("res://Sence/UI/main_game.tscn")


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


func _on_set_song_background_button_pressed() -> void:
	if CurrentSong.HasMv:
		set_song_background_button.text = "BG"
	else: set_song_background_button.text = "MV"
	CurrentSong.HasMv =  !CurrentSong.HasMv
