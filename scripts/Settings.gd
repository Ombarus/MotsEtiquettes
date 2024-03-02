extends Control

var ProfileRoot : Node
var MusicPerLabel : Label
var SFXPerLabel : Label
var MusicSlider : Slider
var SFXSlider : Slider

func _ready() -> void:
	ProfileRoot = $Options/VBoxContainer/ScrollContainer/ProfileList
	MusicPerLabel = $Options/VBoxContainer/Music/Per
	SFXPerLabel = $Options/VBoxContainer/SFX/Per
	MusicSlider = $Options/VBoxContainer/Music/Slider
	SFXSlider = $Options/VBoxContainer/SFX/Slider
	
	Refresh()

func _on_music_value_changed(value: float) -> void:
	MusicPerLabel.text = str(value)
	PermSave.set_attrib("settings.music_volume", value)
	SetBusVolume("Music", value)

func _on_sfx_value_changed(value: float) -> void:
	SFXPerLabel.text = str(value)
	PermSave.set_attrib("settings.sfx_volume", value)
	SetBusVolume("Sfx", value)
	
func SetBusVolume(bus_name : String, raw_value : float) -> void:
	var bus : int = AudioServer.get_bus_index(bus_name)
	var value : float = ConvertToExpDb(raw_value)
	AudioServer.set_bus_volume_db(bus, value)
	if value <= -79:
		AudioServer.set_bus_mute(bus, true)
	else:
		AudioServer.set_bus_mute(bus, false)
		
func ConvertToExpDb(val : float):
	val = clamp(val, 0.0, 100.0)
	# invert because we go from -X db to 0 which is full volume
	val = 100.0 - val
	var base : float = 80.0
	var exp_mult : float = 0.01
	var new_val : float = pow(base, exp_mult * val)
	# 0 means "normal" audio
	# -80db means "mutted"
	return -new_val
	
func _on_delete_pressed(n : Control) -> void:
	var profiles : Array = PermSave.get_attrib("profiles")
	profiles.erase(n.name)
	PermSave.set_attrib("profiles", profiles)
	n.visible = false
	var btn : Button = n.get_node("Delete")
	btn.disconnect("pressed", self, "_on_delete_pressed")
	n.get_parent().remove_child(n)
	n.queue_free()
	Events.emit_signal("ProfileChanged")

func Refresh() -> void:
	var sfx_vol = PermSave.get_attrib("settings.sfx_volume", 70)
	var mus_vol = PermSave.get_attrib("settings.music_volume", 70)
	MusicSlider.value = mus_vol
	SFXSlider.value = sfx_vol
	_on_sfx_value_changed(sfx_vol)
	_on_music_value_changed(mus_vol)
	
	ReloadProfiles()
	
func ReloadProfiles() -> void:
	var c : int = ProfileRoot.get_child_count()
	for i in range(c-1, 0, -1):
		var n : Node = ProfileRoot.get_child(i)
		if n.name == "Example":
			continue
		ProfileRoot.remove_child(n)
		n.queue_free()
		
	var profiles : Array = PermSave.get_attrib("profiles")
	var example = ProfileRoot.get_child(0)
	for pname in profiles:
		var n : Control = example.duplicate()
		n.visible = true
		n.name = pname
		var btn : Button = n.get_node("Delete")
		btn.text = pname
		btn.connect("pressed", self, "_on_delete_pressed", [n])
		ProfileRoot.add_child(n)
		
	
func _on_Close_pressed() -> void:
	self.visible = false
