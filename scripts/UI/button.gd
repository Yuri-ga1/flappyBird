extends Button

@export var button_text: String = "Default Text"

# Called when the node enters the scene tree for the first time.
func _ready():
	var label = $Texture/Text
	var texture_rect = $Texture
	
	label.text = button_text
	
	var text_size = label.get_minimum_size()
	texture_rect.size = text_size + Vector2(22, 22)
	
	custom_minimum_size = texture_rect.size
