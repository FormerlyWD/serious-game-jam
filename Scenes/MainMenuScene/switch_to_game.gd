extends Button

@export var scene_fade_silhouette: SceneFadeSilhouette

func _on_pressed() -> void:
	scene_fade_silhouette.fade_in()
	await scene_fade_silhouette.fade_finished
	GlobalShiftManager.next_shift()
