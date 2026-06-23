extends Label
enum CharacterState {
	ANIMATING,
	FREE
}
@export var post_shift_message_label: Label

var current_character_state:CharacterState = CharacterState.FREE
func start_visible_character_animation():
	if current_character_state == CharacterState.ANIMATING:
		return
	current_character_state = CharacterState.ANIMATING
	
	post_shift_message_label.visible_characters
