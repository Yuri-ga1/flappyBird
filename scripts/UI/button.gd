extends Button

@export var button_text: String = "Default Text"

var label: Label
var texture_rect: TextureRect

# Called when the node enters the scene tree for the first time.
func _ready():
	label = $Texture/Text
	texture_rect = $Texture
	
	label.text = button_text
	var x_size = texture_rect.size.x
	
	var text_size = label.get_minimum_size()
	texture_rect.size = text_size + Vector2(22, 22)
	
	if x_size != texture_rect.size.x:
		var offset = texture_rect.size.x - x_size
		texture_rect.position.x -= offset
		
	custom_minimum_size = texture_rect.size
