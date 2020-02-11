extends Control



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func _on_Play10_toggled(button_pressed):
	Events.emit_signal("StartGame", GetProfileName(), 10)
	self.visible = false


func _on_Play20_toggled(button_pressed):
	Events.emit_signal("StartGame", GetProfileName(), 20)
	self.visible = false


func _on_Play50_toggled(button_pressed):
	Events.emit_signal("StartGame", GetProfileName(), 50)
	self.visible = false

func GetProfileName() -> String:
	var btn : BaseButton = get_node("HBoxContainer/Profile/Profile0").group.get_pressed_button()
	var profile_name = "Default"
	if btn != null:
		profile_name = btn.text
	return profile_name
