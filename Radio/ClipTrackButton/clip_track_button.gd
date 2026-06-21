extends Control
class_name ClipTrackButton
var queue_track_clips: Array[ClipInsertion]
var confirmed_track_clips: Array[ClipInsertion]
@export var delay_intervals:float = 1.0
@export var knob_slider:FrequencyKnob
@export var clip_manager:ClipManagerAudioStream
func _ready() -> void:
	knob_slider.frequency_cleared.connect(check_if_frequency_and_clip_valid)
	clip_manager.new_clip_inserted.connect(check_if_frequency_and_clip_valid)
	%CentralAndStaticNoiseChannels.new_channel_switched.connect(clear_queue)
func check_if_frequency_and_clip_valid():
	print("does it work")
	if knob_slider.is_frequency_cleared and clip_manager.current_play_state == clip_manager.PlayState.BUSY:
		var registered_clip = clip_manager.clip_history_registry[clip_manager.current_clip_parsed.id]
		if queue_track_clips.has(registered_clip):
			return
		print("123")
		queue_track_clips.append(clip_manager.clip_history_registry[clip_manager.current_clip_parsed.id])
		
		
func clear_queue():
	queue_track_clips.clear()
func remove_element(clip_id:int):
	if queue_track_clips.has(clip_manager.clip_history_registry[clip_id]):
		queue_track_clips.erase(clip_manager.clip_history_registry[clip_id])
	


func _on_button_pressed() -> void:
	for clip in queue_track_clips:
		if not clip in confirmed_track_clips:
			$"../Label".text += str(clip.id)
			confirmed_track_clips.append(clip)
	clear_queue()
