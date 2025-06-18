extends Button

@export var SongInfo: Level
@export var Id: int
@onready var difficulty_label: Label = %DifficultyLabel
@onready var song_image: TextureRect = %SongImage
@onready var song_name_label: Label = %SongNameLabel
@onready var song_visual_label: Label = %SongVisualLabel


func _ready() -> void:
	difficulty_label.text = str(SongInfo.Difficulty)
	song_image.texture = SongInfo.BackgroundImage
	song_name_label.text = SongInfo.name.replace("_"," ")
	if SongInfo.HasMv: song_visual_label.text = "MV"
	else: song_visual_label.text = "BG"
	
	


func _on_pressed() -> void:
	var main_menu_node = get_tree().get_first_node_in_group("main_menu")
	main_menu_node.PickedSong(Id)

	
