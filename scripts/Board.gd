extends Control

var _card_array : Array
var _wait_time : float = 0.0
var _play_time : float = 0.0
var _num_play : int = 0
var _num_success : int = 0
var CurrentCard = null

onready var _success : Control = get_node("../Success")
onready var _fail : Control = get_node("../Fail")

# Called when the node enters the scene tree for the first time.
func _ready():
	_card_array.push_back(get_node("GridContainer/Card"))
	_card_array.push_back(get_node("GridContainer/Card2"))
	_card_array.push_back(get_node("GridContainer/Card3"))
	_card_array.push_back(get_node("GridContainer/Card4"))
	
	Play()
	
	Events.connect("OnCardClicked", self, "OnCardClicked_Callback")
	get_node("HBoxContainer/Rate").text = "%d / %d" % [_num_success, _num_play]
	
func Play():
	var names := []
	for i in range(_card_array.size()):
		names.push_back(Preloader.GetRandomName(names))
	
	for i in range(_card_array.size()):
		_card_array[i].Name = names[i]
	
	var good = Preloader.GetRandi(0, _card_array.size()-1)
	CurrentCard = _card_array[good]
	
	get_node("Word").text = CurrentCard.Name
	
func OnCardClicked_Callback(name : String):
	if CurrentCard.Name == name:
		_success.visible = true
		_num_success += 1
	else:
		_fail.visible = true
	
	_num_play += 1
	_wait_time = 0.0
	get_node("HBoxContainer/Rate").text = "%d / %d" % [_num_success, _num_play]
	
func _process(delta : float):
	if _success.visible == true or _fail.visible == true:
		_wait_time += delta
		if _wait_time >= 4.0:
			_success.visible = false
			_fail.visible = false
			Play()
	else:
		_play_time += delta
		get_node("HBoxContainer/Time").text = "%.0f sec" % _play_time

func _input(event):
	if _success.visible == false and _fail.visible == false:
		return
		
	if event is InputEventMouseButton:
		if not event.pressed:
			_success.visible = false
			_fail.visible = false
			Play()
