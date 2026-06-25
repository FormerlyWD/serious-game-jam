extends CenterContainer
class_name SceneClarifier
var current_tween:Tween
@export var duration:float = 0.01
@export var duration_exit:float = 1
@export var inbetween_wait:float
@export var sfx:AudioStream
@export var transition:Tween.TransitionType
func change_text(value:String):
	$Msg.text = value
func flicker_animation():
	
	
	await get_tree().create_timer(inbetween_wait).timeout
	
	if current_tween:
		current_tween.stop()
		current_tween = null
	
	current_tween = create_tween()
	
	current_tween.tween_property(
		$Msg,"modulate:a",1.0,duration
		).set_trans(transition)
	
	
	await current_tween.finished
	
	await get_tree().create_timer(inbetween_wait).timeout
	if current_tween:
		current_tween.stop()
		current_tween = null
	
	current_tween = create_tween()
	current_tween.tween_property(
		$Msg,"modulate:a",0.0,duration_exit
		).set_trans(transition)
