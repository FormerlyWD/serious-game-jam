extends Node2D
@export var scene_fade_silhouette: SceneFadeSilhouette

func _ready() -> void:
	scene_fade_silhouette.fade_out()
