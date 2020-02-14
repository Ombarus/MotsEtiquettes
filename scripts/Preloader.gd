extends Node

var _tex_array := {}
var _rng := RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	_rng.randomize()
	var dir = Directory.new()
	if dir.open("res://data/textures/cards/") == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if file_name.get_extension() == "import":
				file_name = file_name.trim_suffix(".import")
				var key = file_name.trim_suffix(".png")
				var data = load("res://data/textures/cards/" + file_name)
				_tex_array[key] = data
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")

func GetTexture(name : String) -> Texture:
	return _tex_array[name]

func GetRandomName(exclude : Array = []) -> String:
	var rng_max : int = _tex_array.size() - 1
	var index : int = _rng.randi_range(0, rng_max)
	var name : String = _tex_array.keys()[index]
	while name in exclude:
		index = _rng.randi_range(0, rng_max)
		name = _tex_array.keys()[index]
		
	return name
	
func GetRandi(low : int, high : int) -> int:
	return _rng.randi_range(low, high)
