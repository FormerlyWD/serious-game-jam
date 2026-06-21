extends Node
class_name CustomTimer


var current_timer:float
func _process(delta: float) -> void:	
	current_timer +=delta
func reset_timer():
	current_timer = 0
