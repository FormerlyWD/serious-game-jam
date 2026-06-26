extends TextureButton

@export var duration:float = 1
@export var trans_type:Tween.TransitionType
var cur_tween:Tween
func button_fade_in():
	if cur_tween:
		cur_tween.stop()
		cur_tween = null
	cur_tween = create_tween()
	cur_tween.tween_property(self,"modulate:a",1.0,duration)
	await cur_tween.finished
	disabled = false
func button_fade_out():
	if cur_tween:
		cur_tween.stop()
		cur_tween = null
	cur_tween = create_tween()
	cur_tween.tween_property(self,"modulate:a",0.0,duration)
