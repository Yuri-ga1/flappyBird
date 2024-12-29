extends CanvasLayer


@export var settings_menu_scene: PackedScene

var settings_menu: Control = null

signal restart 


func on_settings_back() -> void:
	if settings_menu:
		settings_menu.visible = false
	$BaseButtons.visible = true


func _on_restart_pressed() -> void:
	restart.emit()


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
