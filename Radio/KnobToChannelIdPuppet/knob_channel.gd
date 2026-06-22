extends KnobPuppet
@export var central_and_static_noise_channels: CentralAndStaticNoiseChannels
var last_channel := -1
func on_rotation_change(angle_rad:float):
	var angle_deg := fposmod(rad_to_deg(angle_rad), 360)
	var channel = floor((angle_deg / 360.0) * central_and_static_noise_channels.amount_of_streams)
	if not channel == last_channel:
		last_channel = channel
		central_and_static_noise_channels.switch_channel(channel)
		print("channel_switch_pending...")
