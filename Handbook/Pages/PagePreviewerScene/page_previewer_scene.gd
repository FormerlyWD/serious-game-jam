extends Node2D
@export var include_all:bool
@export var include_array:Array[int]
@export var exclude_all:bool
@export var exclude_array:Array[int]
@export var all_fetched_pages:Array[Page]
func scour_children_for_pages():
	var count:int = 0
	for child in get_children():
		if child is Page:
			if include_all:
				if not count in exclude_array:
					all_fetched_pages.append(child)
					count +=1
			elif exclude_all:
				if count in include_array:
					all_fetched_pages.append(child)
					count +=1
			
			
