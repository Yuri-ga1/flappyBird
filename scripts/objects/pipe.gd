extends Area2D

signal hit
signal scored
signal gravity_reversed

var gravity_spawn_reversal: bool = false

const CHANCE_CHANGE_GRAVITY: int = 20

@export var change_gravity_texture: Texture

func setup_effect():
	gravity_spawn_reversal = randi_range(0, 100) <= CHANCE_CHANGE_GRAVITY
	
	if gravity_spawn_reversal:
		setup_reverce_gravity()

func _on_body_entered(body: Node2D) -> void:
	hit.emit()

func _on_score_area_body_entered(body: Node2D) -> void:
	scored.emit()

	if gravity_spawn_reversal and body.has_method("reverse_gravity"):
		body.reverse_gravity()
	
	
func setup_reverce_gravity():
	var score_area = $ScoreArea
	var sprite = Sprite2D.new()
	sprite.texture = change_gravity_texture
	
	var score_area_collision = score_area.get_node("ScoreAreaCollision")
	
	sprite.position = score_area_collision.position
	
	var extents = score_area_collision.shape.get_size() 
	sprite.scale = extents / sprite.texture.get_size()
	
	sprite.z_index = -1
	sprite.modulate = Color(1, 1, 1, 0.5)
	
	score_area.add_child(sprite)
