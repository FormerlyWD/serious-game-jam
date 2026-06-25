extends Node2D
@export var scene_fade_silhouette: SceneFadeSilhouette

@export var intro_page: Node2D


@export var duration:float = 1
@export var trans_type:Tween.TransitionType
var cur_tween:Tween

func _ready() -> void:
	scene_fade_silhouette.fade_out()
	await scene_fade_silhouette.fade_finished
	if cur_tween:
		cur_tween.stop()
		cur_tween = null
	intro_page.position.y = 700
	cur_tween = create_tween()
	cur_tween.tween_property(intro_page,"position:y",0,duration)
	

func _on_button_pressed() -> void:
	
	if cur_tween:
		cur_tween.stop()
		cur_tween = null
	intro_page.position.y = 0
	cur_tween = create_tween()
	cur_tween.tween_property(intro_page,"position:y",700,duration)
	await cur_tween.finished
	GlobalShiftManager.next_shift()
