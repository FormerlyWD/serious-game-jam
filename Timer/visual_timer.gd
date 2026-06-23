extends Label
class_name VisualTimer
@export var second_to_minute_amount:float = 2.0
var total_minutes: int = 0 # Track total elapsed in-game minutes
var hours
var minutes
@export var starting_time_minutes:float = 20.0
@export var round_to_mins:int= 10
func _ready() -> void:
	format_start_time()
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
	
	var second_to_minute:float = seconds*second_to_minute_amount
	var rounded_stm:int = round(second_to_minute)
	print("not weorking" + str(rounded_stm))
	total_minutes = rounded_stm+starting_time_minutes
	format_time()
