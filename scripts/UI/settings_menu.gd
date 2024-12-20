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
	
	update_sounds_volume()


func update_sounds_volume():
	var sfx_sounds = GameManager.sfx_sounds
	if sfx_sounds.size() > 0:
		var volume = AudioServer.get_bus_volume_db(2)
		
		for sound in sfx_sounds:
			sound.volume_db = volume

func update_music_volume():
	var background_music = GameManager.background_music
	if background_music.size() > 0:
		var volume = AudioServer.get_bus_volume_db(1)
		
		for music in background_music:
			music.volume_db = volume
