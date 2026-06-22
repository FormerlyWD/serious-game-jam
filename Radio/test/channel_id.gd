extends Label
@export var central_and_static_noise_channels: CentralAndStaticNoiseChannels


func _ready() -> void:
	central_and_static_noise_channels.new_channel_switched.connect(text_change)
func text_change():
	text = str(central_and_static_noise_channels.currently_chosen_channel)
