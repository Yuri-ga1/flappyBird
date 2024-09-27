extends CharacterBody2D

const GRAVITY: int = 1000
const MAX_VEL: int = 600
const FLAP_SPEED: int = -500
const START_POS = Vector2(100, 400)

var flying: bool = false
var falling: bool = false

# calling when the node enter the scene for the first time
func _ready() -> void:
	reset()
	
func reset():
	flying = false
	falling = false
	position = START_POS
	set_rotation(0)

# called every frame 
func _physics_process(delta: float) -> void:
	if flying or falling:
		velocity.y += GRAVITY * delta
		if velocity.y > MAX_VEL:
			velocity.y = MAX_VEL
		if flying:
			set_rotation(deg_to_rad(velocity.y*0.05))
			$AnimatedSprite2D.play()
		if falling:
			set_rotation(PI/2)
			$AnimatedSprite2D.stop()
		move_and_collide(velocity * delta)
	else:
		$AnimatedSprite2D.stop()
		
func flap():
	velocity.y = FLAP_SPEED
