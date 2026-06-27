extends AudioStreamPlayer
class_name BgMusic
@export var duration:float = 1
@export var initial_DB:float = -30.0
@export var max_DB:float = 0
@export var transition_type:Tween.TransitionType
var current_tween:Tween
func replace_music(audio_stream:AudioStream):
	stop()
	stream = audio_stream
	
	if audio_stream is AudioStreamWAV:
		pass
	
	
	if current_tween:
		current_tween.stop()
		current_tween = null
	current_tween= create_tween()
	volume_db = initial_DB
	play()
	
	current_tween.tween_property(self, "volume_db", max_DB, duration).set_trans(transition_type)
func stop_stream():
	volume_db = initial_DB
	if current_tween:
		current_tween.stop()
		current_tween = null
	current_tween= create_tween()
	current_tween.tween_property(self, "volume_db", initial_DB, duration).set_trans(transition_type)
	await current_tween.finished
	stop()

func continue_stream():
	replace_music(stream)
func _on_finished() -> void:
	if current_tween:
		current_tween.stop()
		current_tween = null
	current_tween= create_tween()
	current_tween.tween_property(self, "volume_db", initial_DB, duration).set_trans(transition_type)
	await current_tween.finished
	replace_music(stream)
