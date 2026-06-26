extends Container
@export var handbook: Handbook
@export var page_up:bool = false
@export var button: Button
@export var next_page: AudioStreamPlayer

func _ready() -> void:
	button.pressed.connect(on_click)

func on_click():

	if page_up:
		
		if handbook.page_up():
			next_page.play()
	else:
		if handbook.page_down():
			next_page.play()
	
