extends Label
class_name RadioInfo
@export var central_and_static_noise_channels: CentralAndStaticNoiseChannels
@export var knob_slider: FrequencyKnob


func _ready() -> void:
	central_and_static_noise_channels.new_channel_switched.connect(text_change)
	
func text_change():
	var channel:int = (central_and_static_noise_channels.currently_chosen_channel)
	var frequency:int =  (int(round(knob_slider.value/3.63636)))
	
	text = "%2d.%02d" % [channel, frequency]
