extends Control
class_name Radio
signal request_top

@export var clip_manager_audio_stream: ClipManagerAudioStream
@export var central_and_static_noise_channels: CentralAndStaticNoiseChannels
@export var knob_slider: FrequencyKnob
@export var timer:CustomTimer
@export var radio_disabler: RadioDisabler
@export var clip_track_button: ClipTrackButton

@export var visual_timer: VisualTimer

func _ready() -> void:
	timer.radio_finished.connect(radio_finished)
func idle_radio():
	central_and_static_noise_channels.idle_channel_spawn()
func radio_finished():
	
	GlobalShiftManager.currently_focused_shift.post_shift_stats.all_tracked_clips = clip_track_button.confirmed_track_clips 
	
	radio_disabler.disable_clicks()
	%SceneFadeSilhouette.fade_in()
	await %SceneFadeSilhouette.fade_finished
	GlobalShiftManager.finish_shift()

func reset_radio():
	pass
	radio_disabler.enable_functionality()
	timer.reset_timer()
	knob_slider.reset()
	central_and_static_noise_channels.update_stream_count()
	
	clip_manager_audio_stream.fill_clip_insertion_sorted()
	clip_manager_audio_stream.auto_evaluate_clips()
	central_and_static_noise_channels.switch_channel(0)
	
func apply_shift_radio_data(shift_data:Shift):
	timer.maximum_radio_time = shift_data.duration
	if central_and_static_noise_channels:
		central_and_static_noise_channels.channel_array = shift_data.channel_array
		central_and_static_noise_channels.update_stream_count()
	if clip_manager_audio_stream:
		
		clip_manager_audio_stream.evaluate_special_points(shift_data)
		clip_manager_audio_stream.evaluate_special_points_for_scatter_pool(shift_data)
		clip_manager_audio_stream.fill_end_time_for_shift(shift_data)
		$ShiftClipScatterProcessing.scatter_clips(shift_data)
		clip_manager_audio_stream.all_clips_insertions = shift_data.all_clip_insertions
		clip_manager_audio_stream.get_max_points(shift_data)
		clip_manager_audio_stream.randomize_target_point_for_clips(shift_data)
