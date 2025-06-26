extends Resource
class_name Level

@export var name: String
@export var fk_times:= ""
@export var fk_hold := ""
@export var music:AudioStream
@export var BackgroundImage: Texture
@export var BackgroundMV: VideoStream
@export var Difficulty: int
@export var HasMv : bool

@export var category: categoryType 
enum categoryType{
	EternalCity,
	ProjectSekai,
	HeavenBurnRed,
	Mili
	}
