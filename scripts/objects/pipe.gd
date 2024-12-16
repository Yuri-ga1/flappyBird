extends Area2D

signal hit
signal scored
signal mirror_world

var gravity_spawn_reversal: bool = false
var world_mirrored: bool = false

@export var CHANCE_CHANGE_GRAVITY: int
@export var CHANCE_MIRROR_WORLD: int

@export var change_gravity_texture: Texture
@export var mirror_world_texture: Texture

func initialize_pipe(x_position: float, y_position: float) -> void:
	position.x = x_position
	position.y = y_position
	setup_effect()
	

func setup_effect():
	var possible_effects = []
	gravity_spawn_reversal = false
	world_mirrored = false
	
	if randi_range(1, 100) <= CHANCE_CHANGE_GRAVITY:
		possible_effects.append("gravity_reversal")
	 
	if randi_range(1, 100) <= CHANCE_MIRROR_WORLD:
		possible_effects.append("world_mirrored")
		
	if possible_effects.size() > 0:
		var chosen_effect = possible_effects[randi_range(0, possible_effects.size() - 1)]
		
		match chosen_effect:
			"gravity_reversal":
				gravity_spawn_reversal = true
				setup_score_area_sprite(change_gravity_texture)
			"world_mirrored":
				world_mirrored = true
				setup_score_area_sprite(mirror_world_texture)

func _on_body_entered(body: Node2D) -> void:
	hit.emit()

func _on_score_area_body_entered(body: Node2D) -> void:
	if !$ScoreArea/ScoreAreaCollision.disabled:
		scored.emit()
		
		if gravity_spawn_reversal and body.has_method("reverse_gravity"):
			body.reverse_gravity()
		
		if world_mirrored:
			mirror_world.emit()
		
		$ScoreArea/ScoreAreaCollision.disabled = true
	
	
func setup_score_area_sprite(texture: Texture):
	var score_area = $ScoreArea
	var sprite = Sprite2D.new()
	sprite.texture = texture
	
	var score_area_collision = score_area.get_node("ScoreAreaCollision")
	
	sprite.position = score_area_collision.position
	
	var extents = score_area_collision.shape.get_size() 
	sprite.scale = extents / sprite.texture.get_size()
	
	sprite.z_index = -1
	sprite.modulate = Color(1, 1, 1, 0.5)
	
	score_area.add_child(sprite)
