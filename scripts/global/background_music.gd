extends AudioStreamPlayer

@export var bg_music_folder: String = "res://assets/audio/background"

var bg_music: Array[String]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	bg_music = GameManager.get_all_files(bg_music_folder, ".mp3")
	
	stream = load(bg_music.pick_random())
	play()
	finished.connect(play_music)

func play_music():
	if not playing:
		stream = load(bg_music.pick_random())
		play()

func stop_music():
	stop()
