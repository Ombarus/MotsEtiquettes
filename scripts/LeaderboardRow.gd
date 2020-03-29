extends Control
class_name LeaderboardRow

export(StyleBox) var NormalText
export(StyleBox) var HighlightText

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func SetData(data, highlight=false):
	#{"player_name":"Papa", "time_sec":200, "mistake":0, "total":10}
	get_node("Panel/HBoxContainer/name").text = data["player_name"]
	get_node("Panel/HBoxContainer/mistake").text = "%d" % data["mistake"]
	get_node("Panel/HBoxContainer/time").text = "%.0f sec" % data["time_sec"]
	
	if highlight == true:
		get_node("Panel").set("custom_styles/panel", HighlightText)
	else:
		get_node("Panel").set("custom_styles/panel", NormalText)
