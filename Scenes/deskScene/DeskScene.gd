extends Node2D



@export var current_shift_object:Shift
@export var scene_fade_silhouette: SceneFadeSilhouette
@export var scene_clarifier: SceneClarifier
@export var hideable_nodes: HideableNodes

@export var default_bg_music:AudioStream
func _ready() -> void:
	
	
	GlobalShiftManager.choose_new_shift()
	scene_clarifier.change_text("DAY " + str(GlobalShiftManager.current_shift_parse+1))
	scene_clarifier.flicker_animation()
	if scene_fade_silhouette:
		scene_fade_silhouette.fade_out()
	process_shift_object()
func process_shift_object():
	current_shift_object = GlobalShiftManager.currently_focused_shift
	hideable_nodes.initialize()
	if not current_shift_object.hideable_nodes_shown.size() == 0:
		hideable_nodes.show_children(current_shift_object.hideable_nodes_shown)
	
	if current_shift_object.bg_music:
		%BgMusic.replace_music(current_shift_object.bg_music)
	else:
		%BgMusic.replace_music(default_bg_music)
	
	if not GlobalShiftManager.current_shift_parse ==0:
		%RadioNode.apply_shift_radio_data(current_shift_object)
		%RadioNode.reset_radio()
		
	else:
		%RadioNode.radio_disabler.disable_clicks()
		%RadioNode.timer.current_timer_state = CustomTimer.TimerState.LOCKED
	%Handbook.apply_handbook_data(current_shift_object)
	%Handbook.initialize_pages()
