extends HSlider
var is_dragging: bool = false
enum DialDirection {TOMIN, TOMAX}
@export var chosen_target_deg:float = 180
@export var exponential_curviture:float = 2
@export var maximum_value:float = 20
@export var current_dial_direction:DialDirection = DialDirection.TOMIN
func find_dist(new_value:float):
	return 180-abs(180-abs(new_value-chosen_target_deg))
func _on_value_changed(value: float) -> void:
	var distance:float = find_dist(value)
	var distance_ratio:float = distance/180
	match current_dial_direction:
		DialDirection.TOMIN:
			var exponential_increase_ratio:float = 1-(1/pow(exponential_curviture,distance_ratio))
			%ChannelNode.volume_db = maximum_value*exponential_increase_ratio
		DialDirection.TOMAX:
			var exponential_increase_ratio:float = (1/pow(exponential_curviture,distance_ratio))
			%ChannelNode.volume_db = maximum_value*exponential_increase_ratio
