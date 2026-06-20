extends AudioStreamPlayer
class_name CentralAndStaticNoiseChannels

var amount_of_streams:int
var playlist_array :Array[AudioStream]
@export var clip_manager:ClipManagerAudioStream
@export var currently_chosen_channel:int = 0
@export var timer_node:CustomTimer
func _ready() -> void:
	update_stream_count()
	turn_playlist_into_array()
	switch_channel(0)
func turn_playlist_into_array():
	playlist_array.clear()
	var stream_playlist:AudioStreamPlaylist= stream as AudioStreamPlaylist
	if stream_playlist:
		for audio_parse in range(amount_of_streams):
			var audio_track = stream_playlist.get_list_stream(audio_parse)
			playlist_array.append(audio_track)
	
func update_stream_count():
	var stream_playlist:AudioStreamPlaylist= stream as AudioStreamPlaylist
	if stream_playlist:
		amount_of_streams = stream_playlist.get_stream_count()
	if clip_manager:
		clip_manager.fill_clip_insertion_sorted()
		clip_manager.auto_evaluate_clips()
func switch_channel(new_channel:int):
	currently_chosen_channel = new_channel
	stream = playlist_array[currently_chosen_channel]
	play(timer_node.current_timer)
	
	clip_manager.discard_clip_from_play()
	clip_manager.check_clip_state()
