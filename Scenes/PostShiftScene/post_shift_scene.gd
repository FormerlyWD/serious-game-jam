extends Node2D
func _ready() -> void:
	process_stats()
	
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
