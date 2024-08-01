extends Control
class_name PauseMenuUI


@export var first_element_to_grab_focus: Control = null

@onready var body: Panel = $Body
@onready var pause_btn_icon: MarginContainer = $PauseButtonIcon


func _on_resume_button_pressed() -> void:
	self.body.set_visible(false)
	get_tree().set_pause(false)


@export_file("*.scn", "*.tscn") var main_menu_scene_file_path: String = "res://scenes/main_menu.tscn"

func _on_quit_to_main_menu_button_pressed() -> void:
	get_tree().set_pause(false)
	get_tree().change_scene_to_file(main_menu_scene_file_path)


func _ready() -> void:
	self.show()
	self.body.hide()
	assert(first_element_to_grab_focus != null)
	assert(FileAccess.file_exists(self.main_menu_scene_file_path))


func toggle_body_visibile() -> void:
	self.body.set_visible(not self.body.is_visible())
	
	if self.body.is_visible():
		get_tree().set_pause(true)
		first_element_to_grab_focus.grab_focus()
	else:
		get_tree().set_pause(false)


func _unhandled_key_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_pause"):
		get_tree().get_root().set_input_as_handled()
		self.toggle_body_visibile()


func _on_pause_button_pressed() -> void:
	self.toggle_body_visibile()
