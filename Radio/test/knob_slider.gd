extends HSlider
class_name FrequencyKnob


signal frequency_cleared
var is_dragging: bool = false
enum DialDirection {TOMIN, TOMAX}
enum WrapState {NONE,THREESIXTY }
@export var current_wrap_state:WrapState = WrapState.NONE
@export var chosen_target_deg:float = 180

@export var signal_clear_flag_requirement:float = 0.1
@export var clip_volume_outside_curve:float = 0
@export var clip_volume_inside_curve:float = 10
@export var noise_default_volume:float = -10
@export var exponential_curviture:float = 2
@export var maximum_value:float = 20
@export var current_dial_direction:DialDirection = DialDirection.TOMIN
@export var central_static_noise:CentralAndStaticNoiseChannels
@export var clip_manager_audio_stream: ClipManagerAudioStream
@export var radio_info: RadioInfo
@export var is_clip_mute_outside_curve:bool = true
var is_frequency_cleared:bool


func reset():
	clip_manager_audio_stream.volume_db =clip_volume_outside_curve
	
	central_static_noise.volume_db = noise_default_volume
	value = 0 #subject to change
	
func find_dist(new_value:float):
	return 180-abs(180-abs(new_value-chosen_target_deg))
func _on_value_changed(cur_value:float) -> void:
	var distance:float
	match current_wrap_state:
		WrapState.NONE:
			distance =  abs(cur_value-chosen_target_deg)
		WrapState.THREESIXTY:
			distance = find_dist(cur_value)
	var distance_ratio:float = distance/180
	
	#match current_dial_direction:
		#DialDirection.TOMIN:
			#var exponential_increase_ratio:float = 1-(1/pow(exponential_curviture,distance_ratio))
			#if exponential_increase_ratio < signal_clear_flag_requirement:
				#if not is_frequency_cleared:
					#
					#is_frequency_cleared = true
					#clip_manager_audio_stream.volume_db =clip_volume_inside_curve
					#frequency_cleared.emit()
					#get_child(0).visible = true
			#else:
				#if is_frequency_cleared:
					#get_child(0).visible = false
					#clip_manager_audio_stream.volume_db =lerp(clip_volume_outside_curve,clip_volume_inside_curve,exponential_increase_ratio)
					#
					#is_frequency_cleared = false
			#central_static_noise.volume_db = (maximum_value*exponential_increase_ratio)+noise_default_volume
			
	var volume = volume_sech(distance_ratio, 0.1) * 3 - 1
	print(distance_ratio, ' | ', volume)
	is_frequency_cleared = volume > 0.1
	if is_frequency_cleared:
		clip_manager_audio_stream.volume_linear = volume
		frequency_cleared.emit()
	radio_info.text_change()
	
func volume_sech(distance, width): #calculates the volume given a distance using the sech function
	return 1/cosh(distance/width)
