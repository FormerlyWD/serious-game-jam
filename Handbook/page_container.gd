extends Container
@export var handbook: Handbook
@export var page_up:bool = false
@export var button: Button

func _ready() -> void:
	button.pressed.connect(on_click)

func on_click():
	print("123456")
	if page_up:
		
		handbook.page_up()
	else:
		handbook.page_down()
