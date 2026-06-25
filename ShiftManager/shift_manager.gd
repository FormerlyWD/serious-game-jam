extends Node
class_name ShiftManager
signal shifts_finished
@export var all_shifts:Array[Shift]
@export var point_log:PointLog
enum Scene {
	DESK,
	POST_SHIFT
}

@onready var all_scene_paths:Dictionary = {
	Scene.DESK:"res://Scenes/deskScene/DeskScene.tscn",
	Scene.POST_SHIFT:"res://Scenes/PostShiftScene/PostShiftScene.tscn"
}
@export var default_post_shift_stats:PostShiftStats
@export var currently_focused_shift:Shift
@export var current_shift_parse:int = -1

func next_shift():
	
	current_shift_parse +=1
	choose_new_shift()
	get_tree().change_scene_to_file(all_scene_paths[Scene.DESK])
func choose_new_shift():
	if not all_shifts.size() == 0:
		currently_focused_shift = all_shifts[0]
		currently_focused_shift.post_shift_stats = default_post_shift_stats.duplicate()
		all_shifts.pop_front()
	else:
		shifts_finished.emit()
func finish_shift():
	get_tree().change_scene_to_file(all_scene_paths[Scene.POST_SHIFT])
	
 
