extends Node2D
@export var scene_fade_silhouette: SceneFadeSilhouette

@export var intro_page: Node2D

@export var bg_music: BgMusic

@export var duration:float = 1
@export var trans_type:Tween.TransitionType
var cur_tween:Tween

func _ready() -> void:
	bg_music.replace_music(bg_music.stream)
	intro_page.create_outro_message()
	$GoToShift.disabled = true
	scene_fade_silhouette.fade_out()
	await scene_fade_silhouette.fade_finished
	if cur_tween:
		cur_tween.stop()
		cur_tween = null
	intro_page.position.y = 700
	$sfx.play()
	cur_tween = create_tween()
	cur_tween.tween_property(intro_page,"position:y",41,duration).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)
	await cur_tween.finished
	$GoToShift.button_fade_in()
	

func _on_button_pressed() -> void:
	$Label.visible = true
	$GoToShift.button_fade_out()
	if cur_tween:
		cur_tween.stop()
		cur_tween = null
	$sfx2.play()
	cur_tween = create_tween()
	cur_tween.tween_property(intro_page,"position:y",700,duration).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)
	await cur_tween.finished
	
