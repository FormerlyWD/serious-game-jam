extends Node2D
@export var default_bg_music:AudioStream
@export var bg_music: BgMusic
@export var post_shift_message_label: Label
@export var scene_fade_silhouette: SceneFadeSilhouette

func _ready() -> void:
	
	scene_fade_silhouette.fade_out()
	if GlobalShiftManager.currently_focused_shift.post_shift_bg_music:
		bg_music.replace_music(GlobalShiftManager.currently_focused_shift.post_shift_bg_music)
	else:
		bg_music.replace_music(default_bg_music)
		
	
	process_stats()

func process_stats():
	var all_points:float
	var log:String
	for clip in GlobalShiftManager.currently_focused_shift.post_shift_stats.all_tracked_clips:
		
		if clip.designated_clip_tag == ClipInsertion.ClipTags.ALIEN:
			GlobalShiftManager.currently_focused_shift.post_shift_stats.all_accumilated_points += clip.override_points 
			log += "ANOMALY FOUND," + "+" + str(clip.override_points)+ " \n"
			all_points += clip.override_points
			
		elif clip.designated_clip_tag == ClipInsertion.ClipTags.HUMAN:
			GlobalShiftManager.currently_focused_shift.post_shift_stats.all_accumilated_points += clip.override_points 
			log += "MISREPORT," + "-" + str(abs(clip.override_points))+ " \n"
			all_points -= clip.override_points
	GlobalShiftManager.attained_points += all_points
	GlobalShiftManager.all_attainable_points += GlobalShiftManager.currently_focused_shift.accumilatable_points
	
	post_shift_message_label.visible = false
	post_shift_message_label.text = str("TOTAL:")
	post_shift_message_label.text
	post_shift_message_label.text +=str ( all_points) + "/"
	post_shift_message_label.text +=str ( int(GlobalShiftManager.currently_focused_shift.accumilatable_points)) +  " \n"
	post_shift_message_label.text += "LOGS:"+ " \n"
	post_shift_message_label.text += log

			
	post_shift_message_label.start_visible_character_animation()


func _on_button_pressed() -> void:
	GlobalShiftManager.next_shift()
