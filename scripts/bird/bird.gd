extends CharacterBody2D

const GRAVITY: int = 1000
const MAX_VEL: int = 600
const FLAP_SPEED: int = -500
const START_POS = Vector2(100, 400)

var flying: bool = false
var falling: bool = false

var gravity_scale: float = 1.0

var sounds: Array = []

# calling when the node enters the scene for the first time
func _ready() -> void:
	reset()
	for child in get_children():
		if child is AudioStreamPlayer2D:
			sounds.append(child)

func reset():
	flying = false
	falling = false
	gravity_scale = 1.0
	position = START_POS
	set_rotation(0)
	
	for sound in sounds:
		sound.stop()
	
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
	if $Death:
		$Death.play()
	if gravity_scale < 0:
		reverse_gravity()
	set_rotation(PI / 2)
	$AnimatedSprite2D.stop()
