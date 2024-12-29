extends Control


@export var character_scene: PackedScene
@export var settings_menu_scene: PackedScene

@export var min_height: float = 500.0  # Минимальная высота
@export var max_height: float = 500.0  # Максимальная высота


var character: Node2D
var background: Node2D

var is_touch_max_height: bool = false
var settings_menu: Control = null

func _on_ready() -> void:
	background = $Background
	background.scale.y = 1.219
	
	character = character_scene.instantiate()
	add_child(character)
	character.flying = true
	
	$Background_music.play()
	$Background_music.finished.connect(func():
		$Background_music.play()
	)
	

func _process(delta: float) -> void:
	if is_touch_max_height:
		if character.position.y >= min_height:
			is_touch_max_height = false
			
	if not is_touch_max_height:
		character.flap()
		if character.position.y <= max_height:
			is_touch_max_height = true

func _on_play_pressed() -> void:
	if character and character.get_parent():
		character.get_parent().remove_child(character)
		GameManager.character = character
	get_tree().change_scene_to_file("res://scenes/main.tscn")


func _on_settings_pressed() -> void:
	if not settings_menu:
		settings_menu = settings_menu_scene.instantiate()  # Создаём экземпляр SettingsMenu
		add_child(settings_menu)  # Добавляем в текущую сцену
		settings_menu.back_pressed.connect(on_settings_back)
	
	# Скрываем BaseButtons и делаем SettingsMenu видимым
	$BaseButtons.visible = false
	settings_menu.visible = true


func _on_quit_pressed() -> void:
	get_tree().quit()


func on_settings_back() -> void:
	if settings_menu:
		settings_menu.visible = false
	$BaseButtons.visible = true
