extends VBoxContainer

export(PackedScene) var Row : PackedScene
export(int) var GameCount = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	Refresh()
	Events.connect("EndGame", self, "EndGame_Callback")
	
func EndGame_Callback(_time : float, _mistakes : int, _total : int):
	Refresh()
	
func Refresh():
	Clear()
	var leaderboard : Array = PermSave.get_attrib("leaderboard")
	for entry in leaderboard:
		if entry.total == GameCount:
			var n = Row.instance()
			n.SetData(entry)
			call_deferred("add_child", n)

func Clear():
	for row in get_children():
		remove_child(row)
		row.queue_free()
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
