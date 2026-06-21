extends Node2D



@export var current_shift_object:Shift

func _ready() -> void:
	process_shift_object()
func process_shift_object():
	%RadioNode.apply_shift_radio_data(current_shift_object)
	%RadioNode.reset_radio()
