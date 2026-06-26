extends Control
class_name InteractableKnob
const MAX_DIST := 7000
var is_following:bool = false
var is_hovered:bool
var past_angle:float = -1
var past_angle_degrees:float 
@export var knob_limit_at_360:bool = true
@export var knob_puppet:KnobPuppet
var is_disabled:bool = false

@export var knob_slice_count:int

func disable_functionality():
	is_disabled = true
func enable_functionality():
	is_disabled = false
func _gui_input(event: InputEvent) -> void:
	
	
	if Input.is_action_just_pressed("click"):
		if is_hovered:
			is_following = true
	if Input.is_action_just_released("click"):
		is_following = false
func _physics_process(delta: float) -> void:
	if is_following:
		var angle := get_global_mouse_position().angle_to_point($MiddlePosition.global_position) + PI/2
		var angle_deg := fposmod(rad_to_deg(angle), 360)
		
		if knob_slice_count > 0:
			var slice_size = 360 / knob_slice_count
			angle_deg = round(angle_deg / slice_size) * slice_size
			angle = deg_to_rad(angle_deg)
		if knob_limit_at_360:
			if past_angle_degrees >= 0:
				var diff = angle_deg - past_angle_degrees
				if diff > 180:
					angle_deg = 0
				elif diff < -180:
					angle_deg = 359.9
				else:
					past_angle_degrees = angle_deg
				
			else:
				past_angle_degrees = angle_deg
			
			angle = deg_to_rad(angle_deg)

		
		
		$TextureRect.rotation = angle

		
		past_angle = angle
		if not is_disabled:
			if knob_puppet:
				
				knob_puppet.on_rotation_change(angle)
		
func _on_mouse_entered() -> void:
	is_hovered = true


func _on_mouse_exited() -> void:
	is_hovered = false
	
