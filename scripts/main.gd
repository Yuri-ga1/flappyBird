extends Node

@export var pipe_scene: PackedScene
@export var character_scene: PackedScene

var game_running: bool
var game_over: bool
var scroll
var score: int
const SCROLL_SPEED: int = 4
var screen_size: Vector2i
var ground_height: int
var pipes: Array
const PIPE_DELAY: int = 100
const PIPE_RANGE: int = 200

var character: Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_window().size
	ground_height = $Ground.get_node("Sprite2D").texture.get_height()

	character = character_scene.instantiate()
	add_child(character)
	
	new_game()
	
func new_game():
	$GameOver.hide()
	get_tree().call_group('pipes', 'queue_free')
	game_running = false
	game_over = false
	score = 0
	scroll = 0
	$ScoreLabel.text = "SCORE: " + str(score)
	pipes.clear()
	generate_pipes()
	character.reset()
	
func start_game():
	game_running = true
	character.flying = true
	character.flap()
	$PipeTimer.start()

func stop_game():
	$PipeTimer.stop()
	$GameOver.show()
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
		scroll += SCROLL_SPEED
		if scroll >= screen_size.x:
			scroll = 0
		$Ground.position.x = -scroll
		for pipe in pipes:
			pipe.position.x -= SCROLL_SPEED


func _on_pipe_timer_timeout() -> void:
	generate_pipes()

func generate_pipes():
	var pipe = pipe_scene.instantiate()
	pipe.position.x = screen_size.x + PIPE_DELAY
	pipe.position.y = (screen_size.y - ground_height) / 2  + randi_range(-PIPE_RANGE, PIPE_RANGE)
	pipe.setup_effect()
	pipe.hit.connect(bird_hit)
	pipe.scored.connect(scored)
	pipe.gravity_reversed.connect(reverse_gravity)
	add_child(pipe)
	pipes.append(pipe)

func reverse_gravity():
	character.gravity_scale *= -1

func scored():
	score += 1
	$ScoreLabel.text = "SCORE: " + str(score)

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
