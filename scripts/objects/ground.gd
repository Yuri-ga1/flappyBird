extends Area2D

signal hit

func _ready() -> void:
	$Sprite2D.texture = GameManager.ground

func _on_body_entered(body: Node2D) -> void:
	hit.emit()
