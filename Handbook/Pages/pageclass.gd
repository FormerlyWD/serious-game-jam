extends Node
class_name Page
@export var custom_texture:Texture2D
@export var text:String
@export var rich_text_label: RichTextLabel

@export var label:String = "Blank paper"

func set_text():
	rich_text_label.text = text
	
