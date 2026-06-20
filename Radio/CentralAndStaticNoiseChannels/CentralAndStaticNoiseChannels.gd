extends AudioStreamPlayer
class_name CentralAndStaticNoiseChannels

var amount_of_streams:int
@export var clip_manager:ClipManagerAudioStream
@export var currently_chosen_channel:int = 0
func _ready() -> void:
	var stream_playlist:AudioStreamPlaylist= stream as AudioStreamPlaylist
	amount_of_streams = stream_playlist.get_stream_count()
	clip_manager.fill_clip_insertion_sorted()
		
		
