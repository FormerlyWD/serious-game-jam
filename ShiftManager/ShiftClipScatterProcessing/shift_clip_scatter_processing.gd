extends Node
class_name ShiftClipScatterProcessing



enum ScatterMode {
	GLOBAL,
	PER_CHANNEL
}
enum RandomMode {
	WEIGHTED,
	ANY
}
@export var current_random_type:RandomMode = RandomMode.WEIGHTED
@export var scatter_mode: ScatterMode = ScatterMode.GLOBAL
@export var clip_manager_audio_stream: ClipManagerAudioStream
@export var central_and_static_noise_channels: CentralAndStaticNoiseChannels
@export var max_overlap_attempts:int = 100
var all_scatter_clips_queue:Array[ClipScatterContainer]

func get_scatter_queue(shift_data:Shift):
	all_scatter_clips_queue.clear()
	var total_weight:float = 0.0
	for scatter_clip in shift_data.clip_insertion_scatter_pool:
		if not shift_data.on_non_human_anamoly_weight_increase == 0.0:
			if scatter_clip.clip.designated_clip_tag == ClipInsertion.ClipTags.HUMAN:
				scatter_clip.chance_weight += shift_data.on_non_human_anamoly_weight_increase
		total_weight += scatter_clip.chance_weight
	
	for clip_loop in shift_data.clip_insertion_scatter_count:
		var roll_num:float = randf_range(0,total_weight)
		var cumulative:float = 0.0
		
		for scatter_clip in shift_data.clip_insertion_scatter_pool:
			cumulative += scatter_clip.chance_weight
			if roll_num <= cumulative:
				all_scatter_clips_queue.append(scatter_clip)
				break
	
	
		
func scatter_clips(shift_data:Shift) -> void:
	if not shift_data.is_clip_insertion_scatter_enabled:
		return
	var clip_packed_array:Array[ClipInsertion]

	current_random_type = shift_data.current_random_picking_mode
	if current_random_type == RandomMode.WEIGHTED:
		get_scatter_queue(shift_data)
	
	
	
	match scatter_mode:
		ScatterMode.GLOBAL:
			var start_time_intervals:Array[float]= []
			var end_time_intervals:Array[float]= []
			
			for clip in shift_data.all_clip_insertions:
				start_time_intervals.append(clip.start_time)
				end_time_intervals.append(clip.end_time)
			
			for blank in shift_data.all_blanks:
				if blank.block_type == ShiftBlank.BlockType.PREDETERMINED:
					continue
				start_time_intervals.append(blank.start_time)
				end_time_intervals.append(blank.end_time)
				
			for clip_loop in range(shift_data.clip_insertion_scatter_count):
				
				var picked_scatter_container:ClipScatterContainer
				match current_random_type:
					RandomMode.WEIGHTED:
						picked_scatter_container = all_scatter_clips_queue[clip_loop].duplicate()
					RandomMode.ANY:
						picked_scatter_container = shift_data.clip_insertion_scatter_pool.pick_random().duplicate()
				
				var additional_time:float = 0.0
				var clip:ClipInsertion= shift_data.clip_insertion_scatter_pool.pick_random().clip.duplicate()
				
				var interval =generate_non_overlapping_duration(
					clip.duration,
					shift_data.duration+additional_time,
					start_time_intervals,
					end_time_intervals
					)
				
				if not interval:
					continue
				clip.start_time = interval.start
				clip.end_time = interval.end
				
				if clip.designated_channel == -1:
					clip.designated_channel = randi_range(0,central_and_static_noise_channels.amount_of_streams-1)
				start_time_intervals.append(interval.start)
				end_time_intervals.append(interval.end)
				clip_packed_array.append(clip)
		ScatterMode.PER_CHANNEL:
			var channel_count:int = central_and_static_noise_channels.amount_of_streams
			var start_time_intervals:Array[Array]
			start_time_intervals.resize(channel_count)
			var end_time_intervals:Array[Array]
			end_time_intervals.resize(channel_count)
			var persistent_start_time_intervals:Array[float]
			
			var persistent_end_time_intervals:Array[float]
			

			for blank in shift_data.all_blanks:
				if blank.block_type == ShiftBlank.BlockType.PREDETERMINED:
					continue
					
				persistent_start_time_intervals.append(blank.start_time)
				persistent_end_time_intervals.append(blank.end_time)
			for i in channel_count:
				start_time_intervals[i] = []
				end_time_intervals[i] = []
			
			for clip in shift_data.all_clip_insertions:
				start_time_intervals[clip.designated_channel].append(clip.start_time)
				end_time_intervals[clip.designated_channel].append(clip.end_time)
			
			for clip_loop in range(shift_data.clip_insertion_scatter_count):
				var picked_scatter_container:ClipScatterContainer 
				match current_random_type:
					RandomMode.WEIGHTED:
						picked_scatter_container = all_scatter_clips_queue[clip_loop].duplicate()
					RandomMode.ANY:
						picked_scatter_container = shift_data.clip_insertion_scatter_pool.pick_random().duplicate()
				var additional_time:float = 0.0
				var clip:ClipInsertion= picked_scatter_container.clip.duplicate()
				if picked_scatter_container.blank:
					var clip_blank:ClipBlank = picked_scatter_container.blank
					additional_time = randf_range(clip_blank.initial_random_addition_time, clip_blank.final_random_addition_time)
					
					
				
				if clip.designated_channel == -1:
					clip.designated_channel =  randi_range(0,central_and_static_noise_channels.amount_of_streams-1)
				var cur_start_time_intervals:Array[float] = []
				cur_start_time_intervals.assign(start_time_intervals[clip.designated_channel])
				cur_start_time_intervals.append_array(persistent_start_time_intervals)
				var cur_end_time_intervals:Array[float] = []
				cur_end_time_intervals.assign(end_time_intervals[clip.designated_channel])
				cur_end_time_intervals.append_array(persistent_end_time_intervals)
				var interval = generate_non_overlapping_duration(
					clip.duration,
					shift_data.duration+additional_time,
					cur_start_time_intervals ,
					cur_end_time_intervals 
					)
				if not interval:
					continue
				clip.start_time = interval.start
				clip.end_time = interval.end
				start_time_intervals[clip.designated_channel].append(interval.start)
				end_time_intervals[clip.designated_channel].append(interval.end)
				clip_packed_array.append(clip)
				
				
	
	
	shift_data.all_clip_insertions.append_array(clip_packed_array)
func generate_non_overlapping_duration(
	duration:float, 
	maximum_time:float,
	start_times:Array[float],
	end_times:Array[float]
	):
	var attempts:int = 0
	while attempts <max_overlap_attempts:
		attempts+=1
		var start_time = randf() * (maximum_time - duration)
		var end_time = start_time + duration
		var overlaps:bool = false
		for point in start_times.size():
			if intervals_overlap(start_time, end_time, start_times[point], end_times[point]):
				overlaps = true
				break
			
		if not overlaps:
			return {"start":start_time,"end":end_time}
func intervals_overlap(a_start: float, a_end: float, b_start: float, b_end: float):
	return a_start < b_end and b_start < a_end
