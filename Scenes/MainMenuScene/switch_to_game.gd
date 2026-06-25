extends Button

@export var scene_fade_silhouette: SceneFadeSilhouette

func _on_pressed() -> void:
	disabled = true
	$AnimationPlayer.play("press")
	scene_fade_silhouette.fade_in()
	await scene_fade_silhouette.fade_finished

	GlobalShiftManager.switch_scene(GlobalShiftManager.Scene.PAPER_SCENE)


func _on_mouse_entered() -> void:
	if not disabled:
		var tween = get_tree().create_tween()
		tween.tween_property($staticoverlay, "modulate:a", 0.6, 0.1)


func _on_mouse_exited() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property($staticoverlay, "modulate:a", 0, 0.1)

