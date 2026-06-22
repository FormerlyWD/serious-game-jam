extends Control
class_name InteractableKnob
const MAX_DIST := 7000
var is_following:bool = false
var is_hovered:bool
var past_angle:float = -1
var past_angle_degrees:float 
@export var knob_limit_at_360:bool = true
@export var knob_puppet:KnobPuppet
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
		if knob_limit_at_360:
			if not past_angle == -1:
				print("past_angle" + str(past_angle_degrees) + "/angle" + str(angle_deg))
				if past_angle_degrees+180 < angle_deg or past_angle_degrees+180 > angle_deg:
					
					
					angle_deg = past_angle_degrees
					
					$TextureRect.rotation = past_angle
				else:
					past_angle_degrees = fposmod(rad_to_deg(past_angle), 360)
					$TextureRect.rotation = angle
			past_angle = angle
		else:
			
			$TextureRect.rotation = angle
		if knob_puppet:
			
			knob_puppet.on_rotation_change(angle)
		
func _on_mouse_entered() -> void:
	is_hovered = true


func _on_mouse_exited() -> void:
	is_hovered = false
	
