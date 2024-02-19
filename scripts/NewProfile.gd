extends Control

var NameEdit : LineEdit

func _ready() -> void:
	NameEdit = get_node("Control/VBoxContainer/LineEdit")


func _on_Ok_pressed() -> void:
	var profiles : Array = PermSave.get_attrib("profiles")
	profiles.append(NameEdit.text)
	PermSave.set_attrib("profiles", profiles)
	Events.emit_signal("ProfileChanged")
	self.visible = false


func _on_Cancel_pressed() -> void:
	self.visible = false
