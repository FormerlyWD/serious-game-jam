extends AudioStreamPlayer
class_name CentralAndStaticNoiseChannels

var amount_of_streams:int
signal new_channel_switched
@export var channel_array :Array[Channel]
@export var frequency_knob:FrequencyKnob
@export var clip_manager:ClipManagerAudioStream
@export var currently_chosen_channel:int = 0
@export var timer_node:CustomTimer

	
	
func update_stream_count():
	
	if channel_array:
		amount_of_streams = channel_array.size()

func switch_channel(new_channel:int):
	new_channel_switched.emit()
	currently_chosen_channel = new_channel
	frequency_knob.chosen_target_deg = channel_array[currently_chosen_channel].lowest_frequency_point
	frequency_knob._on_value_changed(frequency_knob.value)
	stream = channel_array[currently_chosen_channel].radio_noise
	play(timer_node.current_timer)
	
	clip_manager.discard_clip_from_play(true)
	clip_manager.check_clip_state()
