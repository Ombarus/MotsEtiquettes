extends Node


enum END_GAME_STATE {
	destroyed,
	entropy,
	suicide,
	won
}

const CURRENT_VERSION := 3

#TODO: Might want to add more info about the player (cargo inventory, # of turn spent, etc.
var _perm_save = {
	"version" : CURRENT_VERSION,
	"settings": {
		"default_name":null,
		"full_screen":false,
		"vsync":true,
		"master_volume":4.0,
		"sfx_volume":4.0,
		"music_volume":4.0,
		"difficulty":2,
		"display_fps":false,
		"hide_hud":false,
		"lang":null
	},
	"profiles": ["Clara", "Papa", "Lily", "Maman"],
	"leaderboard": [
		{"player_name":"Papa", "time_sec":200, "mistake":0, "total":10, "datetime":0, "lang":"fr"}
	]
}

var _savefile_name = "user://perm_config.save"

func _ready():
	var tmp = _perm_save
	if File.new().file_exists(_savefile_name):
		var file = File.new()
		file.open(_savefile_name, file.READ)
		var text = file.get_as_text()
		tmp = JSON.parse(text).result
		file.close()
		
		if "version" in tmp and tmp.version == CURRENT_VERSION:
			_perm_save = tmp
		else:
			# TODO: port save instead of reset when game is published
			var msg : String = str(tmp.version) if 'version' in tmp else 'missing'
			print("WARNING : Savefile version does not match (" + msg + " != " + str(CURRENT_VERSION) + "). Perm save reset")

func get_attrib(path, default=null):
	return get_data(_perm_save, path, default)

func set_attrib(path, val, save=true):
	set_data(_perm_save, path, val)
	if save == true:
		save()
	
func save():
	var save_game = File.new()
	save_game.open(_savefile_name, File.WRITE)
	save_game.store_line(to_json(_perm_save))
	save_game.close()
	
	
func get_data(obj, path, default=null):
	if obj == null:
		return default
	var splices = path.split(".", false)
	var sub = obj
	for s in splices:
		if sub.has(s):
			sub = sub[s]
			if typeof(sub) == TYPE_DICTIONARY and sub.has("disabled") and sub["disabled"] == true:
				return default
		else:
			sub = null
			break
	return _check_data(sub, default)
	
	
func set_data(obj, path, val):
	var splices = path.split(".", false)
	var sub = obj
	for i in range(splices.size()-1):
		var s = splices[i]
		if not sub.has(s):
			sub[s] = {}
		sub = sub[s]

	if typeof(val) == TYPE_VECTOR2:
		val = {"__class":"Vector2", "value": var2str(val)}
	elif not typeof(val) in [TYPE_NIL, TYPE_BOOL, TYPE_INT, TYPE_REAL, TYPE_STRING, TYPE_DICTIONARY, TYPE_ARRAY]:
		print("warning: (", path,  " = ", val, ") trying to serialize an unknown type to JSON")
	
	sub[splices[-1]] = val
	
	
func _check_data(val, default):
	if typeof(val) == TYPE_DICTIONARY and val.has("__class"):
		return str2var(val.value)
	else:
		if val == null:
			return default
		else:
			return val
			
func clean_path(path):
	if not "res://" in path and not "user://" in path:
		path = "res://" + path
	
	return path
