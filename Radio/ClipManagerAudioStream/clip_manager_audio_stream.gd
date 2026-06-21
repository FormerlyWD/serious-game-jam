extends AudioStreamPlayer
class_name ClipManagerAudioStream

signal new_clip_inserted

enum PlayState {
	BUSY, FREE, NONREADY
}
enum AvailabilityState {
	LOCKED, AVAILABLE
}
var current_play_state:PlayState = PlayState.NONREADY
var current_availability_state:AvailabilityState = AvailabilityState.AVAILABLE
var all_clips_insertions_sorted:Array[Array]
@export var all_clips_insertions:Array[ClipInsertion]
@export var button_tracker:ClipTrackButton
@export var central_noise_audio_stream:CentralAndStaticNoiseChannels
@export var timer_node:CustomTimer
var current_clip_parsed:ClipInsertion

var clip_history_registry:Dictionary


func _process(delta: float) -> void:
	if current_availability_state == AvailabilityState.LOCKED:
		return
	check_clip_state()
func lock_clips():
	current_availability_state = AvailabilityState.LOCKED
	discard_clip_from_play(true)
func check_clip_state():
	match current_play_state:
		PlayState.NONREADY:
			pass
		PlayState.FREE:
			
			var reparse_condition:bool = true
			while reparse_condition:
				
				if all_clips_insertions_sorted[central_noise_audio_stream.currently_chosen_channel].size() ==0:
					return
				var the_first_clip:ClipInsertion = all_clips_insertions_sorted[central_noise_audio_stream.currently_chosen_channel][0]
				if the_first_clip.start_time > timer_node.current_timer:
					reparse_condition = false
					return
				elif  the_first_clip.start_time <= timer_node.current_timer :
					if the_first_clip.end_time < timer_node.current_timer:
						all_clips_insertions_sorted[central_noise_audio_stream.currently_chosen_channel].pop_front()
						print("pop_front")
						continue
					elif the_first_clip.end_time >= timer_node.current_timer:

						add_clip_to_play(the_first_clip)
						reparse_condition = false
		PlayState.BUSY:
			if current_clip_parsed.end_time <= timer_node.current_timer:
				all_clips_insertions_sorted[central_noise_audio_stream.currently_chosen_channel].pop_front()
				print("removed")
				discard_clip_from_play()
func discard_clip_from_play(from_channel_switch:bool = false):
	var saved_clip_id:int
	if current_clip_parsed:
		saved_clip_id = current_clip_parsed.id
	current_play_state = PlayState.FREE
	stop()
	stream = null
	if from_channel_switch:
		current_clip_parsed= null
		button_tracker.remove_element(saved_clip_id)
		
	elif current_clip_parsed:
		current_clip_parsed= null
		await get_tree().create_timer(button_tracker.delay_intervals).timeout
		button_tracker.remove_element(saved_clip_id)
	else:
		current_clip_parsed= null
func add_clip_to_play(clip:ClipInsertion):
	
	
	current_play_state = PlayState.BUSY
	
	var play_at:float = max(timer_node.current_timer-clip.start_time,0)
	current_clip_parsed= clip
	if clip.audio_clip:
		stream = clip.audio_clip
		play(play_at)
	new_clip_inserted.emit()
func fill_clip_insertion_sorted()-> void:
	all_clips_insertions_sorted.clear() 
	
	var channel_count = central_noise_audio_stream.channel_array.size()
	for i in range(channel_count):
		all_clips_insertions_sorted.append([]) 
	
	current_play_state = PlayState.NONREADY
func auto_evaluate_clips()-> void:
	
	for clip in all_clips_insertions:
		
		
		all_clips_insertions_sorted[clip.designated_channel].append(clip)
		clip.create_id()
		clip_history_registry[clip.id] = clip
		
	for channel_array in all_clips_insertions_sorted:
		channel_array.sort_custom(
			func(a:ClipInsertion, b:ClipInsertion): return a.start_time < b.start_time)
		
func fill_end_time(clip:ClipInsertion, duration_only:bool = false	) -> void:
	if clip.audio_clip:
		clip.duration = clip.audio_clip.get_length()
		if duration_only:
			return

		if not clip.start_time == -1.0:
			if clip.duration == -1.0:
				clip.duration = clip.audio_clip.get_length()
				print("clip.audio_clip.get_length()" + str(clip.audio_clip.get_length()))
	clip.end_time = clip.start_time+ clip.duration
func fill_end_time_for_shift(shift_data:Shift):
	for predetermined_clip in shift_data.all_clip_insertions:
		fill_end_time(predetermined_clip)
	for scatter_clip in shift_data.clip_insertion_scatter_pool:
		fill_end_time(scatter_clip,true)
