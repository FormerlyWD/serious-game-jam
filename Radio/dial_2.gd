extends Control



@export var central_noise_channel:CentralAndStaticNoiseChannels 
func _on_button_button_up() -> void:
	var new_id:int =wrapi(central_noise_channel.currently_chosen_channel+1,0,central_noise_channel.channel_array.size())
	%CentralAndStaticNoiseChannels.switch_channel(new_id)


func _on_button_2_button_up() -> void:
	var new_id:int =  wrapi(central_noise_channel.currently_chosen_channel-1,0,central_noise_channel.channel_array.size())
	%CentralAndStaticNoiseChannels.switch_channel(new_id)
	$Button2.text = str(new_id)
