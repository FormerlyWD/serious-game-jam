extends Control
class_name InteractableKnob
const MAX_DIST := 7000
var is_following:bool = false
var is_hovered:bool
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
		
		$TextureRect.rotation = angle
		if knob_puppet:
			
			knob_puppet.on_rotation_change(angle)
		
func _on_mouse_entered() -> void:
	is_hovered = true


func _on_mouse_exited() -> void:
	is_hovered = false
	
