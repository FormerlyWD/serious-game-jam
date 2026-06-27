extends TextureRect


func pop_out():
	%StickyNoteSound.play()
	await %StickyNoteSound.finished
	queue_free()
func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		pop_out()
		pass 
