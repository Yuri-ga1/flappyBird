extends Control

signal back_pressed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Audio/VBoxContainer/Master.value = db_to_linear(AudioServer.get_bus_volume_db(0))
	$Audio/VBoxContainer/Music.value = db_to_linear(AudioServer.get_bus_volume_db(1))
	$Audio/VBoxContainer/SFX.value = db_to_linear(AudioServer.get_bus_volume_db(2))


func _on_back_pressed() -> void:
	back_pressed.emit()


func _on_apply_pressed() -> void:
	AudioServer.set_bus_volume_db(0, linear_to_db($Audio/VBoxContainer/Master.value))
	AudioServer.set_bus_volume_db(1, linear_to_db($Audio/VBoxContainer/Music.value))
	AudioServer.set_bus_volume_db(2, linear_to_db($Audio/VBoxContainer/SFX.value))
