extends Node
class_name ShiftClipScatterProcessing



enum ScatterMode {
	GLOBAL,
	PER_CHANNEL
}

@export var scatter_mode: ScatterMode = ScatterMode.GLOBAL
@export var clip_manager_audio_stream: ClipManagerAudioStream
@export var central_and_static_noise_channels: CentralAndStaticNoiseChannels
@export var max_overlap_attempts:int = 100


func scatter_clips(shift_data:Shift) -> void:
	if not shift_data.is_clip_insertion_scatter_enabled:
		return
	var clip_packed_array:Array[ClipInsertion]
	match scatter_mode:
		ScatterMode.GLOBAL:
			var start_time_intervals:Array[float]
			var end_time_intervals:Array[float]
			
			for clip in shift_data.all_clip_insertions:
				start_time_intervals.append(clip.start_time)
				end_time_intervals.append(clip.end_time)
			
			for clip_loop in range(shift_data.clip_insertion_scatter_count):
				var clip:ClipInsertion= shift_data.clip_insertion_scatter_pool.pick_random().duplicate()
				
				var interval =generate_non_overlapping_duration(
					clip.duration,
					shift_data.duration,
					start_time_intervals,
					end_time_intervals
					)
				
				clip.start_time = interval.start
				clip.end_time = interval.end
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
			for i in channel_count:
				start_time_intervals[i] = []
				end_time_intervals[i] = []
			
			for clip in shift_data.all_clip_insertions:
				start_time_intervals[clip.designated_channel].append(clip.start_time)
				end_time_intervals[clip.designated_channel].append(clip.end_time)
			
			for clip_loop in range(shift_data.clip_insertion_scatter_count):
				var clip:ClipInsertion= shift_data.clip_insertion_scatter_pool.pick_random().duplicate()
				clip.designated_channel =  randi_range(0,central_and_static_noise_channels.amount_of_streams-1)
				var cur_start_time_intervals:Array[float]
				cur_start_time_intervals.assign(start_time_intervals[clip.designated_channel])
				var cur_end_time_intervals:Array[float]
				cur_end_time_intervals.assign(end_time_intervals[clip.designated_channel])
				var interval = generate_non_overlapping_duration(
					clip.duration,
					shift_data.duration,
					cur_start_time_intervals ,
					cur_end_time_intervals 
					)
				
				clip.start_time = interval.start
				clip.end_time = interval.end
				start_time_intervals[clip.designated_channel].append(interval.start)
				end_time_intervals[clip.designated_channel].append(interval.end)
				clip_packed_array.append(clip)
				
	
	
	shift_data.all_clip_insertions.append_array(clip_packed_array)
	print("l")
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
