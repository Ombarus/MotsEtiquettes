extends Control
class_name LeaderboardRow

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func SetData(data):
	#{"player_name":"Papa", "time_sec":200, "mistake":0, "total":10}
	get_node("HBoxContainer/name").text = data["player_name"]
	get_node("HBoxContainer/mistake").text = "%d" % data["mistake"]
	get_node("HBoxContainer/time").text = "%.0f sec" % data["time_sec"]
