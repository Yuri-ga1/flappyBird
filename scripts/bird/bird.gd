extends CharacterBody2D

@export var death_sounds: Array[AudioStream]
@export var fly_sound: AudioStream

var death_sound_node: AudioStreamPlayer
var fly_sound_node: AudioStreamPlayer

const GRAVITY: int = 1000
const MAX_VEL: int = 600
const FLAP_SPEED: int = -500
const START_POS = Vector2(100, 400)

var flying: bool = false
var falling: bool = false
var is_alive: bool = true

var gravity_scale: float = 1.0

var sounds: Array[AudioStreamPlayer] = []

# calling when the node enters the scene for the first time
func _ready() -> void:
	death_sound_node = $Death
	fly_sound_node = $Fly
	reset()
	

func reset():
	flying = false
	falling = false
	is_alive = true
	gravity_scale = 1.0
	position = START_POS
	set_rotation(0)
	
	stop_sounds()
	
	if scale.y < 0:
		scale.y *= -1

# called every frame 
func _physics_process(delta: float) -> void:
	if flying or falling:
		velocity.y += GRAVITY * gravity_scale * delta
		if velocity.y > MAX_VEL:
			velocity.y = MAX_VEL
		if flying:
			set_rotation(deg_to_rad(velocity.y * 0.05))
			$AnimatedSprite2D.play()
		move_and_collide(velocity * delta)
	else:
		$AnimatedSprite2D.stop()

func flap():
	if $Fly:
		$Fly.play()
	velocity.y = FLAP_SPEED * gravity_scale

func reverse_gravity():
	gravity_scale *= -1
	scale.y *= -1
	
func death():
	if is_alive:
		play_death_sound()
		if gravity_scale < 0:
			reverse_gravity()
		set_rotation(PI / 2)
		$AnimatedSprite2D.stop()
		
	is_alive = false

func play_death_sound():
	if death_sounds.size() > 0:
		var sfx = death_sounds.pick_random()

		death_sound_node.stream = sfx
		death_sound_node.play()

func stop_sounds():
	if death_sound_node.playing:
		death_sound_node.stop()
	
	if fly_sound_node.playing:
		fly_sound_node.stop()
