extends Node
class_name RadioDisabler
@export var all_disables:Array[Control]
@export var all_disables_functionality:Array[Control]
func disable_clicks():
	for control_node in all_disables:
		control_node.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
func disable_functionality():
	for control_node in all_disables_functionality:
		control_node.disable_functionality()
func enable_functionality():
	for control_node in all_disables_functionality:
		control_node.enable_functionality()
func enable_clicks():
	for control_node in all_disables:
		control_node.mouse_filter = Control.MOUSE_FILTER_PASS
