extends Control


@export var character_scene: PackedScene

@export var min_height: float = 500.0  # Минимальная высота
@export var max_height: float = 500.0  # Максимальная высота


var character: Node2D
var is_touch_max_height: bool = false

func _on_ready() -> void:
	character = character_scene.instantiate()
	add_child(character)
	character.flying = true

func _process(delta: float) -> void:
	if is_touch_max_height:
		if character.position.y >= min_height:
			is_touch_max_height = false
			
	if not is_touch_max_height:
		character.flap()
		if character.position.y <= max_height:
			is_touch_max_height = true

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn")


func _on_settings_pressed() -> void:
	pass # Replace with function body.


func _on_quit_pressed() -> void:
	get_tree().quit()
