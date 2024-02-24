extends Control

var ProfileRoot : Node

# Called when the node enters the scene tree for the first time.
func _ready():
	Events.connect("EndGame", self, "EndGame_Callback")
	Events.connect("ProfileChanged", self, "ReloadProfiles")
	ProfileRoot = get_node("HBoxContainer/Profile/ScrollContainer/VBoxContainer")
	ReloadProfiles()

func _on_Play10_toggled(button_pressed):
	if button_pressed:
		Events.emit_signal("StartGame", GetProfileName(), 10)
		self.visible = false


func _on_Play20_toggled(button_pressed):
	if button_pressed:
		Events.emit_signal("StartGame", GetProfileName(), 20)
		self.visible = false


func _on_Play50_toggled(button_pressed):
	if button_pressed:
		Events.emit_signal("StartGame", GetProfileName(), 50)
		self.visible = false


func ReloadProfiles():
	var c : int = ProfileRoot.get_child_count()
	for i in range(c-1, 0, -1):
		var n : Node = ProfileRoot.get_child(i)
		if n.name == "Example":
			continue
		ProfileRoot.remove_child(n)
		n.queue_free()
		
	var profiles = PermSave.get_attrib("profiles")
	var example = ProfileRoot.get_child(0)
	for pname in profiles:
		var n : Button = example.duplicate()
		n.visible = true
		n.name = pname
		n.text = pname
		ProfileRoot.add_child(n)


func GetProfileName() -> String:
	var btn : BaseButton = get_node("HBoxContainer/Profile/ScrollContainer/VBoxContainer/Example").group.get_pressed_button()
	var profile_name = "Default"
	if btn != null:
		profile_name = btn.text
	return profile_name

func EndGame_Callback(time_sec : float, num_success : int, num_play : int):
	var profile = GetProfileName()
	var data = {}
	#{"player_name":"Papa", "time_sec":200, "mistake":0, "total":10}
	data["player_name"] = profile
	data["time_sec"] = time_sec
	data["mistake"] = num_play - num_success
	data["total"] = num_play
	data["datetime"] = OS.get_unix_time()
	data["lang"] = TranslationServer.get_locale()
	
	var leaderboard = PermSave.get_attrib("leaderboard")
	for i in range(leaderboard.size()):
		if leaderboard[i].mistake > data["mistake"]:
			leaderboard.insert(i, data)
			data = null
			break
		elif leaderboard[i].mistake == data["mistake"] and leaderboard[i].time_sec >= data["time_sec"]:
			leaderboard.insert(i, data)
			data = null
			break
	if data != null:
		leaderboard.push_back(data)
		
	if leaderboard.size() > 200:
		leaderboard.pop_back()
		
	PermSave.set_attrib("leaderboard", leaderboard)
	
	
	var btn : BaseButton = get_node("HBoxContainer/Exam/Play10").group.get_pressed_button()
	if btn != null:
		btn.pressed = false


func _on_French_pressed():
	#var lang_str : String = _lang_options.get_item_metadata(ID)
	#PermSave.set_attrib("settings.lang", lang_str)
	TranslationServer.set_locale("fr")
	Events.emit_signal("LangChange")


func _on_English_pressed():
	TranslationServer.set_locale("en")
	Events.emit_signal("LangChange")


func _on_AddProfile_pressed() -> void:
	get_node("NewProfile").visible = true


func _on_Settings_pressed() -> void:
	pass # Replace with function body.
