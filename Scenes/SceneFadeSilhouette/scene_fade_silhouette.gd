extends Node2D
class_name SceneFadeSilhouette
signal fade_finished
@export var duration:float = 1.0
@export var transition_type:Tween.TransitionType 
@export var silhouette: ColorRect

var current_tween:Tween
func fade_in():
	if current_tween:
		current_tween.stop()
		current_tween = null
	
	silhouette.modulate.a = 0.0
	current_tween = get_tree().create_tween()
	current_tween.tween_property(silhouette,"modulate:a",1.0,duration).set_trans(transition_type)
	print("Tween created:", current_tween)
	current_tween.finished.connect(func(): print("Tween finished signal fired"))
	await  current_tween.finished
	fade_finished.emit()
func fade_out():
	if current_tween:
		current_tween.stop()
		current_tween = null
	
	silhouette.modulate.a = 1.0
	current_tween = get_tree().create_tween()
	current_tween.tween_property(silhouette,"modulate:a",0,duration).set_trans(transition_type)
