extends Node2D
class_name HideableNodes


@export var all_children:Array[Node]
var reveal_array:Array[int]
func initialize():
	all_children = get_children()
	for child in all_children:
		child.visible = false
func show_children(reveal_array_override:Array[int]):
	reveal_array = reveal_array_override
	for child in reveal_array:
		if child < all_children.size():
			all_children[child].visible = true
		
