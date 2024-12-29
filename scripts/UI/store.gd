extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	BackgroundMusic.play_music()
	$Background.scale.y = 1.219
