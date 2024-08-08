extends CanvasLayer
class_name MainMenu


@export var first_ui_element_to_focus: Button = null
@export_file("*.scn", "*.tscn") var game_scene_file_path: String = "res://scenes/game.tscn"


func _ready() -> void:
	assert(FileAccess.file_exists(self.game_scene_file_path))
	assert(self.first_ui_element_to_focus != null)
	
	self.first_ui_element_to_focus.grab_focus()
	AudioManager.play_sound(AudioManager.stream_players.music)


func _on_play_sp_button_pressed() -> void:
	Global.set_game_mode(EnumGameModes.GameModes.Singleplayer)
	get_tree().change_scene_to_file(self.game_scene_file_path)
	AudioManager.stop_sound(AudioManager.stream_players.music)


func _on_play_local_mp_button_pressed() -> void:
	Global.set_game_mode(EnumGameModes.GameModes.Multiplayer)
	get_tree().change_scene_to_file(self.game_scene_file_path)
	AudioManager.stop_sound(AudioManager.stream_players.music)
