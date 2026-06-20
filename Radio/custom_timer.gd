extends Node
class_name CustomTimer
@export var max_timer:float
var current_timer:float
func _process(delta: float) -> void:	
	current_timer +=delta
	if current_timer >= max_timer:
		current_timer -= max_timer
