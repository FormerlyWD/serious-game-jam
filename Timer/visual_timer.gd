extends Label
class_name VisualTimer
@export var second_to_minute_amount:float = 2.0
var total_minutes: int = 0 # Track total elapsed in-game minutes
var hours
var minutes
@export var starting_time_minutes:float = 20.0
@export var target_real_time:float = 6*60

var transition_duration: float = 10.0
var elapsed:float = 0.0
var is_transitioning: bool = false
@export var round_to_mins:int= 10
func _ready() -> void:
	format_start_time()
func start_transition_to_6am():
	starting_time_minutes = total_minutes
	elapsed = 0.0
	is_transitioning = true
func _process(delta):
	if is_transitioning:
		elapsed += delta
		var clamped_lerp_weight = clamp(elapsed/transition_duration,0.0,1.0)
		total_minutes = lerp(starting_time_minutes, target_real_time, clamped_lerp_weight)
func format_start_time():
	total_minutes = starting_time_minutes
	format_time()
func format_time():
	hours = (total_minutes / 60) % 24
	
	minutes = total_minutes % 60
	var rounded_minutes: int = (minutes / round_to_mins) * round_to_mins 
	minutes = rounded_minutes
	text = get_am_pm_time()
func get_am_pm_time() -> String:
	var meridian:String = "AM"
	var display_hour = hours
	
	if display_hour >= 12:
		meridian = "PM"
		if display_hour > 12:
			display_hour -= 12
	elif display_hour == 0:
		display_hour = 12
		
	return "%d:%02d %s" % [display_hour, minutes, meridian]
func change_time(seconds:float):
	if not is_transitioning:
		return
	
	elapsed += seconds
	var clamped_lerp_weight = clamp(elapsed/transition_duration,0.0,1.0)
	print("not weorking")
	total_minutes = lerp(starting_time_minutes, target_real_time, clamped_lerp_weight)
	format_time()

	if clamped_lerp_weight >= 1.0:
		is_transitioning = false
		return true
	return false
