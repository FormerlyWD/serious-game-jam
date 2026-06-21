extends Resource
class_name Shift


@export var duration:float = 200
@export var all_clip_insertions :Array[ClipInsertion]
@export var channel_array:Array[Channel]
@export var all_blanks:Array[ShiftBlank]

@export var is_clip_insertion_scatter_enabled:bool
@export var clip_insertion_scatter_count:int = 0
@export var clip_insertion_scatter_pool:Array[ClipInsertion]
