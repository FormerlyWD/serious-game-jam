extends Control
signal request_top

@export var clip_manager_audio_stream: ClipManagerAudioStream
@export var central_and_static_noise_channels: CentralAndStaticNoiseChannels
@export var knob_slider: FrequencyKnob
@export var timer:CustomTimer
func _ready() -> void:
	reset_radio()
func reset_radio():
	pass
	timer.reset_timer()
	knob_slider.reset()
	central_and_static_noise_channels.update_stream_count()
	clip_manager_audio_stream.fill_clip_insertion_sorted()
	clip_manager_audio_stream.auto_evaluate_clips()
	central_and_static_noise_channels.switch_channel(0)
	
