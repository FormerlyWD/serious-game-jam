extends Button

var is_on:bool 
func _on_pressed() -> void:
	is_on = not is_on
	if is_on:
		%BgMusic.stop_stream()
	else:
		%BgMusic.continue_stream()
