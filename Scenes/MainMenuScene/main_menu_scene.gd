extends Node2D
@export var scene_fade_silhouette: SceneFadeSilhouette
@export var default_bg_music:AudioStream
func _ready() -> void:
	$BgMusic.replace_music(default_bg_music)
	
	scene_fade_silhouette.fade_out()
