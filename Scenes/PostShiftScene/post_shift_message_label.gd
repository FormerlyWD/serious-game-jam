extends Label
enum CharacterState {
	ANIMATING,
	FREE
}
@export var post_shift_message_label: Label
@export var duration_per_character:float = 0.05
var current_character_state:CharacterState = CharacterState.FREE
func start_visible_character_animation():
	if current_character_state == CharacterState.ANIMATING:
		return
	current_character_state = CharacterState.ANIMATING
	visible = true
	for charint in text.length():
		post_shift_message_label.visible_characters = charint + 1
		await get_tree().create_timer(duration_per_character).timeout
		
	
	
	
	
