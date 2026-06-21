extends Resource
class_name ShiftBlank

enum BlockType {
	PREDETERMINED,
	SCATTERED
}
@export var start_time:float
@export var end_time:float
@export var block_type:BlockType = BlockType.SCATTERED
