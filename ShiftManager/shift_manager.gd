extends Node
class_name ShiftManager
signal shifts_finished
@export var all_shifts:Array[Shift]
@export var point_log:PointLog
enum Scene {
	DESK,
	POST_SHIFT,
	MAIN_MENU,
	PAPER_SCENE,
	END
}

@onready var all_scene_paths:Dictionary = {
	Scene.DESK:"res://Scenes/deskScene/DeskScene.tscn",
	Scene.POST_SHIFT:"res://Scenes/PostShiftScene/PostShiftScene.tscn",
	Scene.PAPER_SCENE:"res://Scenes/IntroPageScene/IntroPageScene.tscn",
	Scene.END:"res://Scenes/EndScene/EndScene.tscn"
}
@export var default_post_shift_stats:PostShiftStats
@export var currently_focused_shift:Shift
@export var current_shift_parse:int = -1
func switch_scene(scene_enum:Scene):
	get_tree().change_scene_to_file(all_scene_paths[scene_enum])
func next_shift():
	
	current_shift_parse +=1
	if not current_shift_parse == 0:
		if not discard_new_shift():
			get_tree().change_scene_to_file(all_scene_paths[Scene.END])
	choose_new_shift()
	get_tree().change_scene_to_file(all_scene_paths[Scene.DESK])
func discard_new_shift() -> bool:
	all_shifts.pop_front()
	if  all_shifts.size() == 0:
		shifts_finished.emit()
		return false
	return true
func choose_new_shift():
	if not all_shifts.size() == 0:
		currently_focused_shift = all_shifts[0]
		currently_focused_shift.post_shift_stats = default_post_shift_stats.duplicate()
func finish_shift():
	get_tree().change_scene_to_file(all_scene_paths[Scene.POST_SHIFT])
	
 
