extends Node

@export var pipe_scene: PackedScene
@export var background_music: Array[AudioStream]

var game_running: bool
var game_over: bool
var scroll
var score: int
var scroll_speed: int = 4
var screen_size: Vector2i
var ground_height: int
var pipes: Array
const PIPE_DELAY: int = 100
const PIPE_RANGE: int = 200

var is_mirrored: bool = false

var character: Node2D
var camera: Node2D
var score_label: Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_window().size
	ground_height = $Camera/Ground.get_node("Sprite2D").texture.get_height()
	
	camera = $Camera
	score_label = $ScoreLabel
	
	character = GameManager.character
	
	camera.add_child(character)
	
	new_game()
	
func new_game():
	$GameOver.hide()
	cleare_pipes()
	game_running = false
	game_over = false
	score = 0
	scroll = 0
	score_label.text = "SCORE: " + str(score)
	if is_mirrored:
		mirror_world()
	generate_pipes()
	character.reset()
	
func start_game():
	game_running = true
	character.flying = true
	character.flap()
	play_background_music()
	$PipeTimer.start()

func stop_game():
	$PipeTimer.stop()
	$GameOver.show()
	$Background_music.stop()
	character.death()
	character.flying = false
	game_running = false
	game_over = true

func _input(event):
	if !game_over:
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
				if game_running == false:
					start_game()
				else:
					if character.flying:
						character.flap()
						check_top()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if game_running:
		scroll += scroll_speed
		
		if scroll >= screen_size.x or scroll <= 0:
			scroll = 0
		
		$Camera/Ground.position.x = -scroll
		
		for pipe in pipes:
			pipe.position.x -= scroll_speed


func _on_pipe_timer_timeout() -> void:
	generate_pipes()

func generate_pipes():
	var pipe = pipe_scene.instantiate()
	var x_position = screen_size.x + PIPE_DELAY
	var y_position = (screen_size.y - ground_height) / 2 + randi_range(-PIPE_RANGE, PIPE_RANGE)
	
	pipe.initialize_pipe(x_position, y_position)
	
	pipe.hit.connect(bird_hit)
	pipe.scored.connect(_update_score)
	pipe.mirror_world.connect(mirror_world)
	
	camera.add_child(pipe)
	pipes.append(pipe)

func mirror_world():
	is_mirrored = not is_mirrored
	camera.scale.x *= -1
	camera.offset.x *= -1
	score_label.offset_left = (camera.offset.x * 2 + 21.5) if is_mirrored else (camera.offset.x - 410.5)
	

func _update_score():
	score += 1
	score_label.text = "SCORE: " + str(score)

func check_top():
	if character.position.y < 0:
		character.falling = true
		stop_game()

func bird_hit():
	character.falling = true
	stop_game()

func _on_ground_hit():
	character.falling = false
	stop_game()

func _on_game_over_restart():
	new_game()
	
func cleare_pipes():
	get_tree().call_group('pipes', 'queue_free')
	pipes.clear()

func play_background_music():
	if background_music.size() > 0:
		var music = background_music.pick_random()

		$Background_music.stream = music
		$Background_music.play()
		
		$Background_music.finished.connect(func():
			$Background_music.play()
		)
