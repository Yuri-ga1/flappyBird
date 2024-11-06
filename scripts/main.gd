extends Node

@export var pipe_scene: PackedScene
@export var character_scene: PackedScene

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

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_window().size
	ground_height = $Ground.get_node("Sprite2D").texture.get_height()

	character = character_scene.instantiate()
	add_child(character)
	
	new_game()
	
func new_game():
	$GameOver.hide()
	cleare_pipes()
	game_running = false
	game_over = false
	score = 0
	scroll = 0
	$ScoreLabel.text = "SCORE: " + str(score)
	if is_mirrored:
		mirror_world()
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
		if scroll >= screen_size.x:
			scroll = 0
		if scroll <= 0 and is_mirrored:
			scroll = screen_size.x
		
		$Ground.position.x = -scroll
		
		for pipe in pipes:
			pipe.position.x -= scroll_speed


func _on_pipe_timer_timeout() -> void:
	generate_pipes()

func generate_pipes():
	var pipe = pipe_scene.instantiate()
	var x_position = screen_size.x + PIPE_DELAY if not is_mirrored else -PIPE_DELAY
	var y_position = (screen_size.y - ground_height) / 2 + randi_range(-PIPE_RANGE, PIPE_RANGE)
	
	pipe.initialize_pipe(x_position, y_position, is_mirrored)
	
	pipe.hit.connect(bird_hit)
	pipe.scored.connect(scored)
	pipe.mirror_world.connect(mirror_world)
	
	add_child(pipe)
	pipes.append(pipe)

func mirror_world():
	is_mirrored = not is_mirrored
	scroll_speed *= -1
	
	cleare_pipes()
	
	character.position.x = screen_size.x - 100 if is_mirrored else 100
	#character.scale.x *= -1
	
	$Ground.position.x = screen_size.x

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
	
func cleare_pipes():
	get_tree().call_group('pipes', 'queue_free')
	pipes.clear()
