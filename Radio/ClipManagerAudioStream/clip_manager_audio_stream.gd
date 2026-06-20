extends AudioStreamPlayer
class_name ClipManagerAudioStream

enum PlayState {
	BUSY, FREE, NONREADY
}
var current_play_state:PlayState = PlayState.NONREADY
var all_clips_insertions_sorted:Array[Array]
@export var all_clips_insertions:Array[ClipInsertion]
@export var central_noise_audio_stream:CentralAndStaticNoiseChannels
@export var timer_node:CustomTimer
var current_clip_parsed:ClipInsertion
func _ready() -> void:
	pass

func _process(delta: float) -> void:
	check_clip_state()
	
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
<<<<<<< HEAD
=======

>>>>>>> 52267e2571b1c43615eb3f188a0a341eea885dfe
						add_clip_to_play(the_first_clip)
						reparse_condition = false
		PlayState.BUSY:
			if current_clip_parsed.end_time <= timer_node.current_timer:
				discard_clip_from_play()
func discard_clip_from_play():
	current_play_state = PlayState.FREE
	stop()
	current_clip_parsed= null
	stream = null
func add_clip_to_play(clip:ClipInsertion):
	current_play_state = PlayState.BUSY
	var play_at:float = max(timer_node.current_timer-clip.start_time,0)
	current_clip_parsed= clip
	if clip.audio_clip:
		stream = clip.audio_clip
		play(play_at)
	
func fill_clip_insertion_sorted()-> void:
	all_clips_insertions_sorted.clear() 
	
	var channel_count = central_noise_audio_stream.amount_of_streams
	for i in range(channel_count):
		all_clips_insertions_sorted.append([]) 
	
	current_play_state = PlayState.NONREADY
func auto_evaluate_clips()-> void:
	
	for clip in all_clips_insertions:
		fill_end_time(clip)
		all_clips_insertions_sorted[clip.designated_channel].append(clip)
	for channel_array in all_clips_insertions_sorted:
		channel_array.sort_custom(
			func(a:ClipInsertion, b:ClipInsertion): return a.start_time < b.start_time)
		
func fill_end_time(clip:ClipInsertion) -> void:
	if clip.audio_clip:
		

		if not clip.start_time == -1.0:
			if clip.duration == -1.0:
				clip.duration = clip.audio_clip.get_length()
				print("clip.audio_clip.get_length()" + str(clip.audio_clip.get_length()))
	clip.end_time = clip.start_time+ clip.duration
