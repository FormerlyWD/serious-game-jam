extends Node
class_name ShiftClipScatterProcessing



enum ScatterMode {
	GLOBAL,
	PER_CHANNEL
}

@export var scatter_mode: ScatterMode = ScatterMode.GLOBAL
@export var clip_manager_audio_stream: ClipManagerAudioStream
@export var central_and_static_noise_channels: CentralAndStaticNoiseChannels



func scatter_clips(shift_data:Shift) -> void:
	if not shift_data.is_clip_insertion_scatter_enabled:
		return
	
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
	
	shift_data.all_clip_insertions.append_array(shift_data.clip_insertion_scatter_pool)
func generate_non_overlapping_duration(
	duration:float, 
	maximum_time:float,
	start_times:Array[float],
	end_times:Array[float]
	):
	while true:
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
