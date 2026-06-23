extends Node2D



@export var current_shift_object:Shift
@export var default_bg_music:AudioStream
func _ready() -> void:
	GlobalShiftManager.choose_new_shift()
	process_shift_object()
func process_shift_object():
	
	current_shift_object = GlobalShiftManager.currently_focused_shift
	if current_shift_object.bg_music:
		%BgMusic.replace_music(current_shift_object.bg_music)
	else:
		%BgMusic.replace_music(default_bg_music)
	%RadioNode.apply_shift_radio_data(current_shift_object)
	%RadioNode.reset_radio()
	%Handbook.apply_handbook_data(current_shift_object)
	%Handbook.initialize_pages()
