extends AudioStreamPlayer
class_name CentralAndStaticNoiseChannels

var amount_of_streams:int
signal new_channel_switched
@export var channel_array :Array[Channel]
@export var frequency_knob:FrequencyKnob
@export var clip_manager:ClipManagerAudioStream
@export var currently_chosen_channel:int = 0
@export var timer_node:CustomTimer
@export var idle_channel:Channel
@export var idle_time:float = 1.0
var all_locked_channel_nums:Array[int]
var is_ready:bool = true
	
	
func update_stream_count():
	
	if channel_array:
		amount_of_streams = channel_array.size()
	for base_channel in channel_array:
		if base_channel.channel_locked:
			all_locked_channel_nums.append(channel_array.find(base_channel))
func switch_channel(new_channel:int):
	if is_ready:
		is_ready = false
	else:
		return
	
	
	clip_manager.lock_clips()
	
	stop()
	stream = idle_channel.radio_noise
	play(timer_node.current_timer)
	
	await get_tree().create_timer(idle_time).timeout
	new_channel_switched.emit()
	currently_chosen_channel = new_channel
	frequency_knob.chosen_target_deg = channel_array[currently_chosen_channel].lowest_frequency_point
	frequency_knob._on_value_changed(frequency_knob.value)
	
	stop()
	stream = channel_array[currently_chosen_channel].radio_noise
	play(timer_node.current_timer)
	
	

	clip_manager.check_clip_state()
	is_ready = true
func get_random_channel_num() -> int:
	var random_channel_num:int = randi_range(0,amount_of_streams-1)
	while random_channel_num in all_locked_channel_nums:
		random_channel_num = randi_range(0,amount_of_streams-1)
	return random_channel_num
