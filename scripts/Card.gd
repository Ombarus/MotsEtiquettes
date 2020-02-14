extends TextureRect

var Name : String setget set_name, get_name

func get_name() -> String:
	return Name

func set_name(newval : String):
	Name = newval
	Init(Name)

func _ready():
	pass # Replace with function body.

func Init(name : String):
	print("Set texture %s" % name)
	self.texture = Preloader.GetTexture(name)



func _on_Button_pressed():
	Events.emit_signal("OnCardClicked", Name)
