extends Control

signal back_pressed

var master_volume = null
var music_volume = null
var sfx_volume = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	master_volume = $Audio/VBoxContainer/Master.value
	music_volume = $Audio/VBoxContainer/Music.value
	sfx_volume = $Audio/VBoxContainer/SFX.value

	master_volume = db_to_linear(AudioServer.get_bus_volume_db(0))
	music_volume = db_to_linear(AudioServer.get_bus_volume_db(1))
	sfx_volume = db_to_linear(AudioServer.get_bus_volume_db(2))


func _on_back_pressed() -> void:
	back_pressed.emit()


func _on_apply_pressed() -> void:
	AudioServer.set_bus_volume_db(0, linear_to_db(master_volume))
	AudioServer.set_bus_volume_db(1, linear_to_db(music_volume))
	AudioServer.set_bus_volume_db(2, linear_to_db(sfx_volume))
