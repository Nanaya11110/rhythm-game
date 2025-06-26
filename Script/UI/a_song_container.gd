extends Button

@export var SongInfo: Level
@export var Id: int
@onready var difficulty_label: Label = %DifficultyLabel
@onready var song_image: TextureRect = %SongImage
@onready var song_name_label: Label = %SongNameLabel
@onready var song_visual_label: Label = %SongVisualLabel
@onready var TypeBoxContainer: Panel = $MarginContainer/HBoxContainer/Label


func _ready() -> void:
	var OldStyleBox: StyleBoxFlat = TypeBoxContainer.get_theme_stylebox("panel").duplicate()
	difficulty_label.text = str(SongInfo.Difficulty)
	song_image.texture = SongInfo.BackgroundImage
	song_name_label.text = SongInfo.name.replace("_"," ")
	if SongInfo.BackgroundMV:
		song_visual_label.text = "MV"
		OldStyleBox.bg_color = Color(1.0, 0.85, 0.2)
		OldStyleBox.border_color = Color(1.0, 0.7, 0.0)
	else:
		song_visual_label.text = "BG"
		OldStyleBox.bg_color = Color(0.2, 0.6, 1.0)
		OldStyleBox.border_color = Color(0.1, 0.4, 0.8)
		
	TypeBoxContainer.add_theme_stylebox_override("panel",OldStyleBox)
	
	


func _on_pressed() -> void:
	var main_menu_node = get_tree().get_first_node_in_group("main_menu")
	main_menu_node.PickedSong(Id)

	
