extends BaseButton
class_name ButtonWithSounds


@export_file("*.ogg", "*.wav") var btn_select_sound_file_path: String = "res://assets/sound/sound-effects/button_select.wav"
@export_file("*.ogg", "*.wav") var btn_acccept_sound_file_path: String = "res://assets/sound/sound-effects/button_accept.wav"


func _ready() -> void:
	assert(FileAccess.file_exists(btn_select_sound_file_path))
	assert(FileAccess.file_exists(btn_acccept_sound_file_path))


func _on_focus_entered() -> void:
	$AudioStreamPlayer.stream = load(btn_select_sound_file_path)
	$AudioStreamPlayer.play()

func _on_mouse_entered() -> void:
	$AudioStreamPlayer.stream = load(btn_select_sound_file_path)
	$AudioStreamPlayer.play()

func _on_pressed() -> void:
	$AudioStreamPlayer.stream = load(btn_acccept_sound_file_path)
	$AudioStreamPlayer.play()
