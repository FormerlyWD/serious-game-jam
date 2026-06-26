extends AudioStreamPlayer
class_name CentralAndStaticNoiseChannels

var amount_of_streams:int
signal new_channel_switched
@export var channel_array :Array[Channel]
@export var frequency_knob:FrequencyKnob
@export var clip_manager:ClipManagerAudioStream
@export var currently_chosen_channel:int = -1
@export var timer_node:CustomTimer
@export var idle_channel:Channel
@export var is_idle_enabled:bool
@export var idle_time:float = 1.0
var all_locked_channel_nums:Array[int]


var switching_timer: SceneTreeTimer = null
var switching := false
var cancel_switch := false
var queued_channel_num:int
var is_queued_channel_valid : bool
func update_stream_count():
	
	if channel_array:
		amount_of_streams = channel_array.size()
	%KnobChannel.knob_slice_count = amount_of_streams
	for base_channel in channel_array:
		if base_channel.channel_locked:
			all_locked_channel_nums.append(channel_array.find(base_channel))
			
			
			
			

func switch_channel(new_channel:int):
	
	if switching:
		cancel_switch = true
		queued_channel_num = new_channel
		is_queued_channel_valid = true
		switch_start(new_channel)
		return
	
	
	switch_start(new_channel)
func switch_start(new_channel:int):
	switching = true
	cancel_switch = false
	is_queued_channel_valid = false
	switch_process(new_channel)

@warning_ignore("redundant_await")
func idle_channel_spawn():
	stream = idle_channel.radio_noise
	stream.loop = true
	play()
	
func switch_process(new_channel:int):
	clip_manager.lock_clips()
	stop()
	stream = idle_channel.radio_noise
	stream.loop = true
	play(timer_node.current_timer)
	switching_timer = get_tree().create_timer(idle_time)
	
	if is_idle_enabled:
		await switching_timer.timeout
	if cancel_switch:
		
		if is_queued_channel_valid:
			var next:int = queued_channel_num
			is_queued_channel_valid = false
			queued_channel_num = -1
			switch_start(next)
		return

	
	
	
	
	currently_chosen_channel = new_channel
	new_channel_switched.emit()
	frequency_knob.chosen_target_deg = channel_array[currently_chosen_channel].lowest_frequency_point
	frequency_knob._on_value_changed(frequency_knob.value)
	
	stop()
	stream = channel_array[currently_chosen_channel].radio_noise
	stream.loop = true
	play(timer_node.current_timer)
	
	

	clip_manager.check_clip_state()
	switching = false
	clip_manager.current_availability_state = ClipManagerAudioStream.AvailabilityState.AVAILABLE
	

func get_random_channel_num() -> int:
	var random_channel_num:int = randi_range(0,amount_of_streams-1)
	while random_channel_num in all_locked_channel_nums:
		random_channel_num = randi_range(0,amount_of_streams-1)
	return random_channel_num


func _on_finished() -> void:
	pass # Replace with function body.
