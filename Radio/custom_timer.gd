extends Node
class_name CustomTimer
signal radio_finished
enum TimerState {
	RUNNING,
	LOCKED
}
var current_timer_state:TimerState = TimerState.RUNNING
var current_timer:float
var maximum_radio_time:float
func _process(delta: float) -> void:	
	match current_timer_state:
		TimerState.RUNNING:
			current_timer +=delta
			if current_timer >= maximum_radio_time:
				radio_finished.emit()
				current_timer_state = TimerState.LOCKED
		TimerState.LOCKED:
			pass
func reset_timer():
	current_timer = 0
