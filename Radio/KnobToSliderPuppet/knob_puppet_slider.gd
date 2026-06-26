extends KnobPuppet
@export var knob_slider: FrequencyKnob

func on_rotation_change(angle_rad:float):
	var angle_deg := fposmod(rad_to_deg(angle_rad), 360)
	knob_slider.value = angle_deg
	knob_slider._on_value_changed(angle_deg)
