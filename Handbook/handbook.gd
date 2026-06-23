extends Control
class_name Handbook
@export var all_pages:Array[Page]
@export var page_previewer_scene: PagePreviewerScene
@export var left_page_container: Container
@export var right_page_container: Container
@export var default_page_previewer_inclusion:PagePreviewerIncludeResource
var page_pointer:int = 0
var left_pointer:int
var right_pointer:int


func apply_handbook_data(shift_data:Shift):
	if shift_data.page_previewer_inclusion:
		page_previewer_scene.page_include = shift_data.page_previewer_inclusion
	else:
		page_previewer_scene.page_include = default_page_previewer_inclusion
func page_up():
	page_pointer = clamp(page_pointer+2,0,page_previewer_scene.all_fetched_pages.size() -2)
	update_book_faces()
	apply_pointer()

func page_down():
	page_pointer = clamp(page_pointer-2,0,page_previewer_scene.all_fetched_pages.size()-2 )
	update_book_faces()
	apply_pointer()
func _input(event: InputEvent) -> void:
	pass
func initialize_pages():
	page_previewer_scene.scour_children_for_pages()
	page_pointer = 0
	update_book_faces()
	apply_pointer()
func update_book_faces():
	left_pointer = page_pointer
	right_pointer = left_pointer +1
func apply_pointer():
	for child in left_page_container.get_children():
		if child is Page:
			child.reparent(page_previewer_scene)
	for child in right_page_container.get_children():
		if child is Page:
			child.reparent(page_previewer_scene)
	
	if left_pointer < page_previewer_scene.all_fetched_pages.size():
		pass
		var left_page:Page = page_previewer_scene.all_fetched_pages[left_pointer]
		add_page_to_container(left_page, left_page_container)
	if right_pointer < page_previewer_scene.all_fetched_pages.size():
		var right_page:Page = page_previewer_scene.all_fetched_pages[right_pointer]
		add_page_to_container(right_page, right_page_container)
func add_page_to_container(page:Page, container:Container):
	if container.get_child_count() > 0:
		if container.get_child(0) is Page:
			container.get_child(0).reparent(page_previewer_scene)
	page.reparent(container)

	page.anchor_left = 0
	page.anchor_top = 0
	page.anchor_right = 1
	page.anchor_bottom = 1

	page.offset_left = 0
	page.offset_top = 0
	page.offset_right = 0
	page.offset_bottom = 0
