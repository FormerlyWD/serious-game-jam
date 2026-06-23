extends AudioStreamPlayer
class_name BgMusic
func replace_music(audio_stream:AudioStream):
	stop()
	stream = audio_stream
	
	if audio_stream is AudioStreamWAV:
		pass

	play()


func _on_finished() -> void:
	
	play()
