extends Label
class_name RadioInfo
@export var central_and_static_noise_channels: CentralAndStaticNoiseChannels
@export var knob_slider: FrequencyKnob


func _ready() -> void:
	central_and_static_noise_channels.new_channel_switched.connect(text_change)
	
func text_change():
	text = str(central_and_static_noise_channels.currently_chosen_channel) + "." + str(int(round(knob_slider.value/3.63636)))
