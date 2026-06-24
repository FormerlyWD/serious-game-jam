extends Node2D
class_name handbookButton
enum BookShownState {SHOWN, INVISIBLE}
@export var initial_y_position:float
@export var final_y_position:float
@export var duration:float
@export var transition_type:Tween.TransitionType
@export var handbook: Handbook
@export var back_button: Button

var current_tween:Tween
var is_animating:bool
var current_book_shown_state:BookShownState = BookShownState.INVISIBLE
func _on_handbook_pressed() -> void:
	match current_book_shown_state:
		BookShownState.INVISIBLE:
			
			current_book_shown_state = BookShownState.SHOWN
			
			%RadioNode.radio_disabler.disable_clicks()
			if current_tween:
				current_tween.stop()
			current_tween = null
			$handbook.disabled = true
			$AnimationPlayer.play("pickup")
			
			await $AnimationPlayer.animation_finished
			back_button.disabled = false
			
			current_tween = create_tween()
			
			current_tween.tween_property(
				handbook,"position:y",final_y_position,duration).set_trans(transition_type)
			
			
		BookShownState.SHOWN:
			back_button.disabled = true
			current_book_shown_state = BookShownState.INVISIBLE
			if current_tween:
				current_tween.stop()
			current_tween = null
			current_tween = create_tween()
			current_tween.tween_property(
				handbook,"position:y",initial_y_position,duration).set_trans(transition_type)
			
			await current_tween.finished
			$AnimationPlayer.play_backwards("pickup")
			
			await $AnimationPlayer.animation_finished
			$handbook.disabled = false
			%RadioNode.radio_disabler.enable_clicks()
		


func _on_button_pressed() -> void:
	_on_handbook_pressed()
