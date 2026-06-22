extends Node2D
class_name PagePreviewerScene
@export var page_include:PagePreviewerIncludeResource 
@export var all_fetched_pages:Array[Page]
func scour_children_for_pages():
	var count:int = 0
	for child in get_children():
		if child is Page:
			if page_include.include_all:
				if not count in page_include.exclude_array:
					all_fetched_pages.append(child)
					count +=1
			elif page_include.exclude_all:
				if count in page_include.include_array:
					all_fetched_pages.append(child)
					count +=1
			
			
