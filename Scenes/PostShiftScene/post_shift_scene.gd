extends Node2D
@export var default_bg_music:AudioStream
@export var bg_music: BgMusic

func _ready() -> void:
	process_stats()
	if GlobalShiftManager.currently_focused_shift.post_shift_bg_music:
		bg_music.replace_music(GlobalShiftManager.currently_focused_shift.post_shift_bg_music)
	else:
		bg_music.replace_music(default_bg_music)
func process_stats():
	for clip in GlobalShiftManager.currently_focused_shift.post_shift_stats.all_tracked_clips:
		
		if clip.designated_clip_tag == ClipInsertion.ClipTags.ALIEN:
			GlobalShiftManager.currently_focused_shift.post_shift_stats.all_accumilated_points += clip.override_points 
			$Label.text += "Alien found," + "+" + str(clip.override_points)+ " \n"
		elif clip.designated_clip_tag == ClipInsertion.ClipTags.HUMAN:
			GlobalShiftManager.currently_focused_shift.post_shift_stats.all_accumilated_points += clip.override_points 
			$Label.text += "Human misreported ," + "-" + str(abs(clip.override_points))+ " \n"
			
		


func _on_button_pressed() -> void:
	GlobalShiftManager.next_shift()
