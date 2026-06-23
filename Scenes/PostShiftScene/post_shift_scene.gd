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
	post_shift_message_label.visible = false
	for clip in GlobalShiftManager.currently_focused_shift.post_shift_stats.all_tracked_clips:
		
		if clip.designated_clip_tag == ClipInsertion.ClipTags.ALIEN:
			GlobalShiftManager.currently_focused_shift.post_shift_stats.all_accumilated_points += clip.override_points 
			post_shift_message_label.text += "Alien found," + "+" + str(clip.override_points)+ " \n"
		elif clip.designated_clip_tag == ClipInsertion.ClipTags.HUMAN:
			GlobalShiftManager.currently_focused_shift.post_shift_stats.all_accumilated_points += clip.override_points 
			post_shift_message_label.text += "Human misreported ," + "-" + str(abs(clip.override_points))+ " \n"
			
	post_shift_message_label.start_visible_character_animation()


func _on_button_pressed() -> void:
	GlobalShiftManager.next_shift()
