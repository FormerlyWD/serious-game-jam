extends Resource

class_name ClipInsertion

static var NEXT_ID := 0
enum ClipTags {
	HUMAN,
	ALIEN
}
@export var audio_clip:AudioStream
@export var designated_clip_tag:ClipTags = ClipTags.HUMAN
@export var designated_channel:int
@export var start_time:float = -1
@export var duration:float = -1
@export var end_time:float = -1

@export var special_points_requirement:PointLog
@export var override_points:int
@export var special_points_addition:PointLog
var id

func create_id():
	id = NEXT_ID
	NEXT_ID += 1
