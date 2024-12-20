extends CharacterBody2D

@export var death_sounds: Array[AudioStream]
@export var fly_sound: AudioStream

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
	reset()
	add_fly_sound()
	

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
	if $Fly_sound:
		$Fly_sound.play()
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

func add_fly_sound():
	var player = AudioStreamPlayer.new()
	var sfx_volume = AudioServer.get_bus_volume_db(2)

	player.stream = fly_sound
	player.name = "Fly_sound"

	player.volume_db = sfx_volume
	player.bus = "SFX"

	add_child(player)
	
	sounds.append(player)
	GameManager.sfx_sounds.append(player)

func play_death_sound():
	if death_sounds.size() > 0:
		var index = randi_range(0, death_sounds.size()-1)
		var player = AudioStreamPlayer.new()
		
		var sfx_volume = AudioServer.get_bus_volume_db(2)

		player.stream = death_sounds[index]
		player.name = 'Death_sound'
		player.volume_db = sfx_volume

		add_child(player)
		player.play()
		
		sounds.append(player)
		player.finished.connect(func():
			player.queue_free()
		)


func stop_sounds():
	for player in sounds:
		if not is_instance_valid(player):
			sounds.erase(player)
			GameManager.sfx_sounds.erase(player)
		elif player.name != "Fly_sound":
			if player.is_playing:
				player.stop()
			
			player.queue_free()
			sounds.erase(player)
			GameManager.sfx_sounds.erase(player)
	
	add_fly_sound()
