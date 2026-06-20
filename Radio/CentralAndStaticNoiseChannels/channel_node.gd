extends AudioStreamPlayer


var amount_of_streams:float
func _ready() -> void:
	var stream_playlist:AudioStreamPlaylist= stream as AudioStreamPlaylist
	amount_of_streams = stream_playlist.get_stream_count()
